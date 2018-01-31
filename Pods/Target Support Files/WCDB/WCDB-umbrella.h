#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WCDB.h"
#import "abstract.h"
#import "clause_join.hpp"
#import "column.hpp"
#import "column_def.hpp"
#import "column_index.hpp"
#import "column_result.hpp"
#import "column_type.hpp"
#import "conflict.hpp"
#import "constraint_table.hpp"
#import "declare.hpp"
#import "describable.hpp"
#import "expr.hpp"
#import "foreign_key.hpp"
#import "fts_module.hpp"
#import "fts_modules.hpp"
#import "handle.hpp"
#import "handle_statement.hpp"
#import "literal_value.hpp"
#import "module_argument.hpp"
#import "order.hpp"
#import "order_term.hpp"
#import "pragma.hpp"
#import "statement.hpp"
#import "statement_alter_table.hpp"
#import "statement_attach.hpp"
#import "statement_create_index.hpp"
#import "statement_create_table.hpp"
#import "statement_create_virtual_table.hpp"
#import "statement_delete.hpp"
#import "statement_detach.hpp"
#import "statement_drop_index.hpp"
#import "statement_drop_table.hpp"
#import "statement_explain.hpp"
#import "statement_insert.hpp"
#import "statement_pragma.hpp"
#import "statement_reindex.hpp"
#import "statement_release.hpp"
#import "statement_rollback.hpp"
#import "statement_savepoint.hpp"
#import "statement_select.hpp"
#import "statement_transaction.hpp"
#import "statement_update.hpp"
#import "statement_vacuum.hpp"
#import "subquery.hpp"
#import "config.hpp"
#import "core_base.hpp"
#import "database.hpp"
#import "handle_pool.hpp"
#import "handle_recyclable.hpp"
#import "statement_recyclable.hpp"
#import "tokenizer.hpp"
#import "transaction.hpp"
#import "WCTMaster+WCTTableCoding.h"
#import "WCTMaster.h"
#import "WCTSequence+WCTTableCoding.h"
#import "WCTSequence.h"
#import "WCTChainCall+Private.h"
#import "WCTChainCall.h"
#import "WCTDelete+Private.h"
#import "WCTDelete.h"
#import "WCTInsert+Private.h"
#import "WCTInsert.h"
#import "WCTInterface+ChainCall.h"
#import "WCTMultiSelect+Private.h"
#import "WCTMultiSelect.h"
#import "WCTRowSelect+Private.h"
#import "WCTRowSelect.h"
#import "WCTSelect+Private.h"
#import "WCTSelect.h"
#import "WCTSelectBase+NoARC.h"
#import "WCTSelectBase+Private.h"
#import "WCTSelectBase.h"
#import "WCTTable+ChainCall.h"
#import "WCTUpdate+Private.h"
#import "WCTUpdate.h"
#import "WCTCompatible.h"
#import "WCTDatabase+Compatible.h"
#import "WCTStatement+Compatible.h"
#import "WCTStatistics+Compatible.h"
#import "WCTTransaction+Compatible.h"
#import "WCTInterface+Convenient.h"
#import "WCTTable+Convenient.h"
#import "WCTCore+Private.h"
#import "WCTCore.h"
#import "WCTDatabase+Core.h"
#import "WCTInterface+Core.h"
#import "WCTStatement+Private.h"
#import "WCTStatement.h"
#import "WCTValue.h"
#import "WCTDatabase+Database.h"
#import "WCTDatabase+File.h"
#import "WCTDatabase+Private.h"
#import "WCTDatabase+RepairKit.h"
#import "WCTDatabase.h"
#import "WCTDeclare.h"
#import "WCTInterface.h"
#import "WCTTable.h"
#import "WCTDatabase+FTS.h"
#import "WCTTokenizer+Apple.h"
#import "WCTTokenizer+WCDB.h"
#import "WCTBaseAccessor.h"
#import "WCTCppAccessor.h"
#import "WCTObjCAccessor.h"
#import "WCTRuntimeBaseAccessor.h"
#import "WCTRuntimeCppAccessor.h"
#import "WCTRuntimeObjCAccessor.h"
#import "WCTBinding.h"
#import "WCTColumnBinding.h"
#import "WCTConstraintBinding.h"
#import "WCTIndexBinding.h"
#import "WCTAnyProperty.h"
#import "WCTCoding.h"
#import "WCTExpr.h"
#import "WCTProperty.h"
#import "WCTPropertyBase.h"
#import "WCTResult.h"
#import "WCTSelectBase+WCTExpr.h"
#import "WCTCodingMacro.h"
#import "WCTConstraintMacro.h"
#import "WCTIndexMacro.h"
#import "WCTMacroHelper.h"
#import "WCTPropertyMacro.h"
#import "WCTORM.h"
#import "WCTChainCall+Statistics.h"
#import "WCTDatabase+Statistics.h"
#import "WCTError+Private.h"
#import "WCTError.h"
#import "WCTStatistics.h"
#import "WCTTransaction+Statistics.h"
#import "WCTDatabase+Table.h"
#import "WCTInterface+Table.h"
#import "WCTTable+Database.h"
#import "WCTTable+Private.h"
#import "WCTTransaction+Table.h"
#import "WCTDatabase+Transaction.h"
#import "WCTTransaction+Private.h"
#import "WCTTransaction.h"
#import "concurrent_list.hpp"
#import "error.hpp"
#import "file.hpp"
#import "macro.hpp"
#import "path.hpp"
#import "recyclable.hpp"
#import "rwlock.hpp"
#import "spin.hpp"
#import "thread_local.hpp"
#import "ticker.hpp"
#import "timed_queue.hpp"
#import "utility.hpp"

FOUNDATION_EXPORT double WCDBVersionNumber;
FOUNDATION_EXPORT const unsigned char WCDBVersionString[];

