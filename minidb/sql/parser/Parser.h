/**
  ******************************************************************************
  * @file           : Parser.h
  * @author         : xy
  * @brief          : None
  * @attention      : None
  * @date           : 2025/5/7
  ******************************************************************************
  */

#ifndef MINIDB_MINIDB_SQL_PARSER_PARSER_H_
#define MINIDB_MINIDB_SQL_PARSER_PARSER_H_

/* 解析的目标 SQL 语句
# select a, b from t1;
# select a, b from t1 where a > c;
# select a, b from t1 where a > c order by b;
# select a, count(a) from t1 group by a where b > 100;
*/

namespace minidb {

class Parser {

};

} // minidb

#endif //MINIDB_MINIDB_SQL_PARSER_PARSER_H_
