/* SPDX-License-Identifier: GPL-2.0-only */
/* Real Venus and OF lookup functions; host-only reference/changeset stubs.
 * This does not execute Linux kobject/sysfs teardown or any device driver.
 */
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

struct device_node {
    const char *full_name;
    struct device_node *parent, *child, *sibling;
    int refs;
};
struct of_changeset {
    struct device_node *nodes[4];
    bool property[4], applied;
    unsigned int count;
};
struct device { struct device_node *of_node; };
struct venus_core { struct of_changeset *ocs; struct device *dev; };
static struct device_node pool[32], *of_root;
static unsigned int used, assertions, creates, messages;
static bool fail_create, fail_property;
static int devtree_lock;
#define CHECK(c) do { assertions++; if (!(c)) { \
    fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #c); exit(1); } } while (0)
#define raw_spin_lock_irqsave(lock, flags) do { (void)(lock); (flags) = 0; } while (0)
#define raw_spin_unlock_irqrestore(lock, flags) do { (void)(lock); (void)(flags); } while (0)
#define dev_err(dev, ...) do { (void)(dev); messages++; } while (0)
static const char *kbasename(const char *s)
{
    const char *p = strrchr(s, '/');
    return p ? p + 1 : s;
}
static struct device_node *of_node_get(struct device_node *n)
{
    if (n) { CHECK(n->refs > 0); n->refs++; }
    return n;
}
static void of_node_put(struct device_node *n)
{
    if (n) { CHECK(n->refs > 0); n->refs--; }
}
#include "of-lookup-functions.h"

static struct device_node *node(const char *name)
{
    CHECK(used < sizeof(pool) / sizeof(pool[0]));
    struct device_node *n = &pool[used++];
    *n = (struct device_node){ .full_name = name, .refs = 1 };
    return n;
}
static void append(struct device_node *p, struct device_node *n)
{
    struct device_node **next = &p->child;
    while (*next) next = &(*next)->sibling;
    *next = n; n->parent = p; n->sibling = NULL;
}
/* Model ownership: creator + ATTACH entry + optional property entry.
 * Apply/revert model only the child and parent references held by sysfs.
 */
static struct device_node *of_changeset_create_node(struct of_changeset *c,
                                                     struct device_node *p,
                                                     const char *name)
{
    creates++;
    if (fail_create) return NULL;
    CHECK(c->count < 4);
    struct device_node *n = node(name);
    n->parent = p;
    c->nodes[c->count++] = of_node_get(n);
    return n;
}
static int of_changeset_add_prop_string(struct of_changeset *c,
                                       struct device_node *n,
                                       const char *key, const char *value)
{
    CHECK(!strcmp(key, "compatible") && value && *value);
    if (fail_property) return -ENOMEM;
    CHECK(c->count && c->nodes[c->count - 1] == n);
    c->property[c->count - 1] = true;
    of_node_get(n);
    return 0;
}
static void apply(struct of_changeset *c)
{
    CHECK(!c->applied);
    for (unsigned int i = 0; i < c->count; i++) {
        struct device_node *n = c->nodes[i];
        of_node_get(n->parent); of_node_get(n);
        append(n->parent, n);
    }
    c->applied = true;
}
static void destroy(struct of_changeset *c)
{
    for (unsigned int i = c->count; i; i--) {
        struct device_node *n = c->nodes[i - 1];
        if (c->applied) {
            struct device_node **link = &n->parent->child;
            while (*link && *link != n) link = &(*link)->sibling;
            CHECK(*link == n); *link = n->sibling;
            of_node_put(n); of_node_put(n->parent);
        }
        if (c->property[i - 1]) of_node_put(n);
        of_node_put(n);
        CHECK(n->refs == 0);
    }
    *c = (struct of_changeset){0};
}
#include "venus-node-function.h"

static void reset_tree(struct venus_core *v, struct device *dev,
                       struct of_changeset *c)
{
    memset(pool, 0, sizeof(pool)); used = creates = messages = 0;
    fail_create = fail_property = false;
    *c = (struct of_changeset){0};
    of_root = node("/");
    struct device_node *p = node("video-codec@aa00000");
    p->refs = 8; /* Easily see a drop without pretending to simulate kobject. */
    append(of_root, p);
    dev->of_node = p; v->dev = dev; v->ocs = c;
}
static int add(struct venus_core *v, const char *name)
{
    return venus_add_video_core(v, name, "venus-decoder");
}
int main(int argc, char **argv)
{
    struct venus_core v; struct device dev; struct of_changeset c;
    const char *mode = argc == 2 ? argv[1] : "all";
    reset_tree(&v, &dev, &c);
    if (!strcmp(mode, "parent")) {
        CHECK(add(&v, "video-decoder") == 0);
        if (dev.of_node->refs != 8) {
            fprintf(stderr, "FAIL borrowed parent refcount: got %d expected 8\n", dev.of_node->refs);
            return 1;
        }
        destroy(&c);
        return 0;
    }
    if (!strcmp(mode, "foreign")) {
        struct device_node *other = node("another-codec");
        append(of_root, other); append(other, node("video-decoder"));
        CHECK(add(&v, "video-decoder") == 0);
        if (creates != 1) {
            fprintf(stderr, "FAIL unrelated device child incorrectly suppresses Venus child creation\n");
            return 1;
        }
        destroy(&c);
        return 0;
    }
    CHECK(!strcmp(mode, "all"));
    CHECK(add(&v, NULL) == 0 && !creates && dev.of_node->refs == 8);
    CHECK(add(&v, "video-decoder") == 0);
    CHECK(add(&v, "video-encoder") == 0);
    CHECK(dev.of_node->refs == 8 && creates == 2);
    apply(&c); CHECK(dev.of_node->refs == 10);
    destroy(&c); CHECK(dev.of_node->refs == 8 && !dev.of_node->child);

    reset_tree(&v, &dev, &c);
    struct device_node *child = node("video-decoder"); append(dev.of_node, child);
    CHECK(add(&v, "video-decoder") == 0);
    CHECK(!creates && child->refs == 1 && dev.of_node->refs == 8);
    /* of_node_name_eq() also accepts a child with unit address. */
    child->full_name = "video-decoder@0";
    CHECK(add(&v, "video-decoder") == 0 && !creates && child->refs == 1);

    reset_tree(&v, &dev, &c);
    struct device_node *other = node("another-codec"); append(of_root, other);
    struct device_node *foreign = node("video-decoder"); append(other, foreign);
    CHECK(add(&v, "video-decoder") == 0 && creates == 1);
    CHECK(dev.of_node->refs == 8 && foreign->refs == 1);
    destroy(&c);

    reset_tree(&v, &dev, &c);
    struct device_node *container = node("unrelated-subtree"); append(dev.of_node, container);
    struct device_node *grandchild = node("video-decoder"); append(container, grandchild);
    CHECK(add(&v, "video-decoder") == 0 && creates == 1);
    CHECK(grandchild->refs == 1 && container->refs == 1 && dev.of_node->refs == 8);
    destroy(&c);

    reset_tree(&v, &dev, &c); fail_create = true;
    CHECK(add(&v, "video-decoder") == -ENODEV);
    CHECK(dev.of_node->refs == 8 && messages == 1 && !c.count);
    destroy(&c);
    reset_tree(&v, &dev, &c); fail_property = true;
    CHECK(add(&v, "video-decoder") == -ENOMEM);
    CHECK(dev.of_node->refs == 8 && messages == 1 && c.count == 1);
    destroy(&c);

    /* Repeated success and rollback, with a fresh allocation pool per cycle. */
    for (unsigned int cycle = 0; cycle < 8; cycle++) {
        reset_tree(&v, &dev, &c);
        CHECK(add(&v, "video-decoder") == 0);
        fail_property = cycle & 1;
        CHECK(add(&v, "video-encoder") == (fail_property ? -ENOMEM : 0));
        CHECK(dev.of_node->refs == 8);
        if (!fail_property) apply(&c);
        destroy(&c);
        CHECK(dev.of_node->refs == 8 && !dev.of_node->child);
    }
    printf("PASS: %u assertions; real Venus/OF lookup code, host refcount/changeset stubs; no kernel teardown or hardware exercised\n", assertions);
    return 0;
}
