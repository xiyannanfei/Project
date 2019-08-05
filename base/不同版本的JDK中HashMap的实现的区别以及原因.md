## JDK7

JDK7 中hashmap 是通过 桶（数组）加链表的数据结构来实现的。当发生hash碰撞的时候，以链表的形式进行存储。

```java
    Entry<K,V>[] table  // 桶
    public V put(K key, V value) {
        if (table == EMPTY_TABLE) {
            inflateTable(threshold);
        }
        if (key == null)
            return putForNullKey(value);
        int hash = hash(key);
        int i = indexFor(hash, table.length); // 对hash值索引桶的位置
        for (Entry<K,V> e = table[i]; e != null; e = e.next) {
            Object k;
            if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
                V oldValue = e.value;
                e.value = value;
                e.recordAccess(this);
                return oldValue;
            }
        }

        modCount++;
        addEntry(hash, key, value, i); // 添加
        return null;
    }
    
    void addEntry(int hash, K key, V value, int bucketIndex) {
        if ((size >= threshold) && (null != table[bucketIndex])) {
            resize(2 * table.length);
            hash = (null != key) ? hash(key) : 0;
            bucketIndex = indexFor(hash, table.length);// 对hash值索引桶的位置
        }

        createEntry(hash, key, value, bucketIndex);
    }
    
    void createEntry(int hash, K key, V value, int bucketIndex) {
        Entry<K,V> e = table[bucketIndex];
        table[bucketIndex] = new Entry<>(hash, key, value, e); // 添加到桶上，并将新增entry的next 指针指向原该位置上的entry，
        size++;
    }
    
    Entry(int h, K k, V v, Entry<K,V> n) {
        value = v;
        next = n;
        key = k;
        hash = h;
    }
```

## JDK 8

JDK7 中hashmap 增加了在原有桶（数组） + 链表的基础上增加了黑红树的使用。当一个hash碰撞的数量超过指定次数(TREEIFY_THRESHOLD)的时候，链表将转化为红黑树结构。

```java
static final int TREEIFY_THRESHOLD = 8; 

final V putVal(int hash, K key, V value, boolean onlyIfAbsent,boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        if ((tab = table) == null || (n = tab.length) == 0){
            n = (tab = resize()).length;
            }
        if ((p = tab[i = (n - 1) & hash]) == null){
            tab[i] = newNode(hash, key, value, null);
        }else {
            Node<K,V> e; K k;
            if (p.hash == hash &&((k = p.key) == key || (key != null && key.equals(k)))){
                e = p;
            }else if (p instanceof TreeNode){
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            }else {
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        if (binCount >= TREEIFY_THRESHOLD - 1){ // -1 for 1st
                            treeifyBin(tab, hash);  // 转化为红黑树
                        }
                        break;
                    }
                    if (e.hash == hash &&((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    }
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                }
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold){
            resize();
        }
        afterNodeInsertion(evict);
        return null;
    }
```

先对key进行hash，找到桶中对应的位置。如果该位置为空，则直接写入。如果该位置已存在node对象则：

* 新增的key 与 已有的key 相同时，则替换原先key对应的value

* 该位置的node是TreeNode 则新增将添加的node转为TreeNode添加到红黑树上

* 否则，遍历该位置的node链表，如果有找到相同的key，则进行替换。如果没有，则添加到最后。当链表的节点数量超过TREEIFY_THRESHOLD阈值的时候，则将链表转化为红黑树结构。

红黑树 时间复杂度为O(lgn)， 而链表的时间复杂度是O(n).当hash碰撞的情况比较严重的情况下，红黑树的查找速度要优于链表。


