# mysql 常用命令
## 创建用户

```
CREATE USER 'root'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'test'@'192.168.1.18' IDENTIFIED BY '123456';
CREATE USER 'test'@'%' IDENTIFIED BY '123456';
```

## 修改用户

```
RENAME USER 'root'@'%' TO 'root'@'localhost';
RENAME USER 'root'@'localhost' TO 'root'@'127.0.0.1';
```

## 给用户分配权限

```
grant all on *.* to 'root'@'localhost';
grant all on lianhuastreet.* to 'test'@'192.168.1.18';

flush privileges;
```