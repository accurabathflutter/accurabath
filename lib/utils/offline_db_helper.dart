import 'dart:async';

import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/bluetone_inquiry_product.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/models/common/assembly/qt_assembly_table.dart';
import 'package:for_practice_the_app/models/common/assembly/sb_assembly_table.dart';
import 'package:for_practice_the_app/models/common/assembly/so_assembly_table.dart';
import 'package:for_practice_the_app/models/common/contact_model.dart';
import 'package:for_practice_the_app/models/common/dealer/purchase_bill/other_charge_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/purchase_bill/product_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/sales_bill/other_charge_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/sales_bill/productl_db_table.dart';
import 'package:for_practice_the_app/models/common/final_checking_items.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/inquiry_product_model.dart';
import 'package:for_practice_the_app/models/common/other_charge_table.dart';
import 'package:for_practice_the_app/models/common/packingProductAssamblyTable.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/models/common/sale_bill_other_charge_table.dart';
import 'package:for_practice_the_app/models/common/sales_bill_table.dart';
import 'package:for_practice_the_app/models/common/sales_order_table.dart';
import 'package:for_practice_the_app/models/common/so_other_charge_table.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/utils/sales_order_payment_schedule.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbHelper {
  static OfflineDbHelper _offlineDbHelper;
  static Database database;

  static const TABLE_CONTACTS = "contacts";
  static const TABLE_INQUIRY_PRODUCT = "inquiry_product";
  static const TABLE_QUOTATION_PRODUCT = "quotation_product";
  static const TABLE_QUOTATION_OLD_PRODUCT = "quotation_old_product";

  static const TABLE_SALES_ORDER_PRODUCT = "sales_order_product";
  static const TABLE_SALES_BILL_PRODUCT = "sales_bill_product";

  static const TABLE_QUOTATION_OTHERCHARGE_TABLE = "quotation_other_charge";
  static const TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE =
      "packing_product_assambly_table";
  static const TABLE_FINAL_CHECKING_ITEM_TABLE = "final_checking_table";
  static const TABLE_SALES_ORDER_OTHERCHARGE_TABLE = "sales_order_other_charge";
  static const TABLE_SALES_BILL_OTHERCHARGE_TABLE = "sales_bill_other_charge";
  static const TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE =
      "sales_order_payment_schedule";

  static const TABLE_DEALER_PURCHASE_TABLE = "dealer_purchase_table";
  static const TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE =
      "dealer_purchase_other_charge";
  static const TABLE_DEALER_SALESBILL_PRODUCT_TABLE =
      "dealer_sales_bill_product_table";
  static const TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE =
      "dealer_sales_bill_other_charge";
  static const TABLE_QUOTATION_SPECIFICATION_TABLE =
      "quotation_specification_table";

  static const TABLE_GENERIC_ADDITIONAL_CHARGES = "generic_additional_charges";
  static const TABLE_QT_ASSEMBLY = "quotation_assembly_table";
  static const TABLE_SO_ASSEMBLY = "salesOrder_assembly_table";
  static const TABLE_SB_ASSEMBLY = "salesBill_assembly_table";
  static const TABLE_BLUETON_PRODUCT = "BlueToneProductModel";
  static const TABLE_BLUETON_PRICE = "pricetable";

  //GenericAddditionalCharges

/*  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
      join(await getDatabasesPath(), 'soleoserp_database.db'),
      onCreate: (db, version) {
        return db.execute(


          'CREATE TABLE $TABLE_CONTACTS(id INTEGER PRIMARY KEY AUTOINCREMENT, pkId TEXT,CustomerID TEXT, ContactDesignationName TEXT, ContactDesigCode1 TEXT, CompanyId TEXT, ContactPerson1 TEXT, ContactNumber1 TEXT, ContactEmail1 TEXT, LoginUserID TEXT)',
         // 'CREATE TABLE $TABLE_INQUIRY_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InquiryNo TEXT,LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, Quantity TEXT, UnitPrice TEXT)',

        );

      },
      version: 2,
    );
  }*/

  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
        join(await getDatabasesPath(), 'soleoserp_database.db'),
        onCreate: (db, version) => _createDb(db),
        version: 16);
  }

  static void _createDb(Database db) {
    db.execute(
      'CREATE TABLE $TABLE_CONTACTS(id INTEGER PRIMARY KEY AUTOINCREMENT, pkId TEXT,CustomerID TEXT, ContactDesignationName TEXT, ContactDesigCode1 TEXT, CompanyId TEXT, ContactPerson1 TEXT, ContactNumber1 TEXT, ContactEmail1 TEXT, LoginUserID TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_INQUIRY_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InquiryNo TEXT,LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, Quantity TEXT, UnitPrice TEXT,TotalAmount TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_QUOTATION_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, QuotationNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_QUOTATION_OLD_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, QuotationNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE)',
    );
    //

    db.execute(
      'CREATE TABLE $TABLE_QUOTATION_OTHERCHARGE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Headerdiscount DOUBLE,Tot_BasicAmt DOUBLE,OtherChargeWithTaxamt DOUBLE,Tot_GstAmt DOUBLE,OtherChargeExcludeTaxamt DOUBLE,Tot_NetAmount DOUBLE,ChargeID1 INTEGER,ChargeAmt1 DOUBLE,ChargeBasicAmt1 DOUBLE,ChargeGSTAmt1 DOUBLE,ChargeID2 INTEGER,ChargeAmt2 DOUBLE,ChargeBasicAmt2 DOUBLE,ChargeGSTAmt2 DOUBLE,ChargeID3 INTEGER,ChargeAmt3 DOUBLE,ChargeBasicAmt3 DOUBLE,ChargeGSTAmt3 DOUBLE,ChargeID4 INTEGER,ChargeAmt4 DOUBLE,ChargeBasicAmt4 DOUBLE,ChargeGSTAmt4 DOUBLE,ChargeID5 INTEGER,ChargeAmt5 DOUBLE,ChargeBasicAmt5 DOUBLE,ChargeGSTAmt5 DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_DEALER_PURCHASE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT, QuotationNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Headerdiscount DOUBLE,Tot_BasicAmt DOUBLE,OtherChargeWithTaxamt DOUBLE,Tot_GstAmt DOUBLE,OtherChargeExcludeTaxamt DOUBLE,Tot_NetAmount DOUBLE,ChargeID1 INTEGER,ChargeAmt1 DOUBLE,ChargeBasicAmt1 DOUBLE,ChargeGSTAmt1 DOUBLE,ChargeID2 INTEGER,ChargeAmt2 DOUBLE,ChargeBasicAmt2 DOUBLE,ChargeGSTAmt2 DOUBLE,ChargeID3 INTEGER,ChargeAmt3 DOUBLE,ChargeBasicAmt3 DOUBLE,ChargeGSTAmt3 DOUBLE,ChargeID4 INTEGER,ChargeAmt4 DOUBLE,ChargeBasicAmt4 DOUBLE,ChargeGSTAmt4 DOUBLE,ChargeID5 INTEGER,ChargeAmt5 DOUBLE,ChargeBasicAmt5 DOUBLE,ChargeGSTAmt5 DOUBLE)',
    );

    ///--------------------
    db.execute(
      'CREATE TABLE $TABLE_DEALER_SALESBILL_PRODUCT_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT, QuotationNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Headerdiscount DOUBLE,Tot_BasicAmt DOUBLE,OtherChargeWithTaxamt DOUBLE,Tot_GstAmt DOUBLE,OtherChargeExcludeTaxamt DOUBLE,Tot_NetAmount DOUBLE,ChargeID1 INTEGER,ChargeAmt1 DOUBLE,ChargeBasicAmt1 DOUBLE,ChargeGSTAmt1 DOUBLE,ChargeID2 INTEGER,ChargeAmt2 DOUBLE,ChargeBasicAmt2 DOUBLE,ChargeGSTAmt2 DOUBLE,ChargeID3 INTEGER,ChargeAmt3 DOUBLE,ChargeBasicAmt3 DOUBLE,ChargeGSTAmt3 DOUBLE,ChargeID4 INTEGER,ChargeAmt4 DOUBLE,ChargeBasicAmt4 DOUBLE,ChargeGSTAmt4 DOUBLE,ChargeID5 INTEGER,ChargeAmt5 DOUBLE,ChargeBasicAmt5 DOUBLE,ChargeGSTAmt5 DOUBLE)',
    );

    ///_____________________
    db.execute(
      'CREATE TABLE $TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,PCNo TEXT,FinishProductID INTEGER,FinishProductName TEXT,ProductGroupID INTEGER,ProductGroupName TEXT,ProductID INTEGER,ProductName TEXT,Unit TEXT,Quantity DOUBLE,ProductSpecification TEXT,Remarks TEXT,LoginUserID TEXT,CompanyId TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_FINAL_CHECKING_ITEM_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,CheckingNo TEXT,CustomerID TEXT,Item TEXT,Checked TEXT,Remarks TEXT,SerialNo TEXT,SRno TEXT,LoginUserID TEXT,CompanyId TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SALES_ORDER_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, SalesOrderNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE,DeliveryDate TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SALES_ORDER_OTHERCHARGE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Headerdiscount DOUBLE,Tot_BasicAmt DOUBLE,OtherChargeWithTaxamt DOUBLE,Tot_GstAmt DOUBLE,OtherChargeExcludeTaxamt DOUBLE,Tot_NetAmount DOUBLE,ChargeID1 INTEGER,ChargeAmt1 DOUBLE,ChargeBasicAmt1 DOUBLE,ChargeGSTAmt1 DOUBLE,ChargeID2 INTEGER,ChargeAmt2 DOUBLE,ChargeBasicAmt2 DOUBLE,ChargeGSTAmt2 DOUBLE,ChargeID3 INTEGER,ChargeAmt3 DOUBLE,ChargeBasicAmt3 DOUBLE,ChargeGSTAmt3 DOUBLE,ChargeID4 INTEGER,ChargeAmt4 DOUBLE,ChargeBasicAmt4 DOUBLE,ChargeGSTAmt4 DOUBLE,ChargeID5 INTEGER,ChargeAmt5 DOUBLE,ChargeBasicAmt5 DOUBLE,ChargeGSTAmt5 DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SALES_BILL_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, QuotationNo TEXT, ProductSpecification TEXT , ProductID INTEGER, ProductName TEXT, Unit TEXT, Quantity DOUBLE, UnitRate DOUBLE, DiscountPercent DOUBLE, DiscountAmt DOUBLE ,NetRate DOUBLE, Amount DOUBLE, TaxRate DOUBLE, TaxAmount DOUBLE, NetAmount DOUBLE, TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SALES_BILL_OTHERCHARGE_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Headerdiscount DOUBLE,Tot_BasicAmt DOUBLE,OtherChargeWithTaxamt DOUBLE,Tot_GstAmt DOUBLE,OtherChargeExcludeTaxamt DOUBLE,Tot_NetAmount DOUBLE,ChargeID1 INTEGER,ChargeAmt1 DOUBLE,ChargeBasicAmt1 DOUBLE,ChargeGSTAmt1 DOUBLE,ChargeID2 INTEGER,ChargeAmt2 DOUBLE,ChargeBasicAmt2 DOUBLE,ChargeGSTAmt2 DOUBLE,ChargeID3 INTEGER,ChargeAmt3 DOUBLE,ChargeBasicAmt3 DOUBLE,ChargeGSTAmt3 DOUBLE,ChargeID4 INTEGER,ChargeAmt4 DOUBLE,ChargeBasicAmt4 DOUBLE,ChargeGSTAmt4 DOUBLE,ChargeID5 INTEGER,ChargeAmt5 DOUBLE,ChargeBasicAmt5 DOUBLE,ChargeGSTAmt5 DOUBLE)',
    );

    db.execute(
      'CREATE TABLE $TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,Amount DOUBLE, DueDate TEXT, RevDueDate TEXT)',
    );

    db.execute(
      'CREATE TABLE $TABLE_QUOTATION_SPECIFICATION_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT,OrderNo TEXT, Group_Description TEXT, Head TEXT, Specification TEXT, Material_Remarks TEXT , QuotationNo TEXT , ProductID TEXT)',
    );

    db.execute(
      'CREATE TABLE $TABLE_GENERIC_ADDITIONAL_CHARGES(id INTEGER PRIMARY KEY AUTOINCREMENT,DiscountAmt TEXT, ChargeID1 TEXT, ChargeAmt1 TEXT, ChargeID2 TEXT, ChargeAmt2 TEXT, ChargeID3 TEXT,ChargeAmt3 TEXT, ChargeID4 TEXT, ChargeAmt4 TEXT, ChargeID5 TEXT, ChargeAmt5 TEXT, ChargeName1 TEXT, ChargeName2 TEXT, ChargeName3 TEXT, ChargeName4 TEXT, ChargeName5 TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_QT_ASSEMBLY(id INTEGER PRIMARY KEY AUTOINCREMENT,FinishProductID TEXT, ProductID TEXT, ProductName TEXT, Quantity TEXT, Unit TEXT, QuotationNo TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SO_ASSEMBLY(id INTEGER PRIMARY KEY AUTOINCREMENT,FinishProductID TEXT, ProductID TEXT, ProductName TEXT, Quantity TEXT, Unit TEXT, OrderNo TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_SB_ASSEMBLY(id INTEGER PRIMARY KEY AUTOINCREMENT,FinishProductID TEXT, ProductID TEXT, ProductName TEXT, Quantity TEXT, Unit TEXT, InvoiceNo TEXT)',
    );

    db.execute(
      'CREATE TABLE $TABLE_BLUETON_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT,InquiryNo TEXT, LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, UnitPrice TEXT)',
    );

    db.execute(
      'CREATE TABLE $TABLE_BLUETON_PRICE(id INTEGER PRIMARY KEY AUTOINCREMENT,ProductID TEXT, ProductName TEXT, SizeID TEXT , SizeName TEXT , isChecked TEXT )',
    );
  }

  static OfflineDbHelper getInstance() {
    return _offlineDbHelper;
  }

  ///Here Customer Contact Table Implimentation

  Future<int> insertContact(ContactModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_CONTACTS,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ContactModel>> getContacts() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_CONTACTS);

    return List.generate(maps.length, (i) {
      return ContactModel(
        maps[i]['pkId'],
        maps[i]['CustomerID'],
        maps[i]['ContactDesignationName'],
        maps[i]['ContactDesigCode1'],
        maps[i]['CompanyId'],
        maps[i]['ContactPerson1'],
        maps[i]['ContactNumber1'],
        maps[i]['ContactEmail1'],
        maps[i]['LoginUserID'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateContact(ContactModel model) async {
    final db = await database;

    await db.update(
      TABLE_CONTACTS,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await database;

    await db.delete(
      TABLE_CONTACTS,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContactTable() async {
    final db = await database;

    await db.delete(TABLE_CONTACTS);
  }

  ///Here InquiryProduct Table Implimentation

  Future<int> insertInquiryProduct(InquiryProductModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_INQUIRY_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InquiryProductModel>> getInquiryProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_INQUIRY_PRODUCT);

    return List.generate(maps.length, (i) {
      return InquiryProductModel(
        maps[i]['InquiryNo'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['ProductName'],
        maps[i]['ProductID'],
        maps[i]['Quantity'],
        maps[i]['UnitPrice'],
        maps[i]['TotalAmount'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateInquiryProduct(InquiryProductModel model) async {
    final db = await database;

    await db.update(
      TABLE_INQUIRY_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteInquiryProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_INQUIRY_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLInquiryProduct() async {
    final db = await database;

    await db.delete(TABLE_INQUIRY_PRODUCT);
  }

  ///Here QuotationProduct Table Implimentation

  Future<int> insertQuotationProduct(QuotationTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_QUOTATION_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuotationTable>> getQuotationProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_QUOTATION_PRODUCT);

    return List.generate(maps.length, (i) {
/*  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  double UnitRate;
  double Disc;
  double NetRate;
  double Amount;
  double TaxPer;
  double TaxAmount;
  double NetAmount;
  bool IsTaxType;
*/
      return QuotationTable(
        maps[i]['QuotationNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateQuotationProduct(QuotationTable model) async {
    final db = await database;

    await db.update(
      TABLE_QUOTATION_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteQuotationProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_QUOTATION_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLQuotationProduct() async {
    final db = await database;

    await db.delete(TABLE_QUOTATION_PRODUCT);
  }

  ///OLD_ProductCRUD

  Future<int> insertOldQuotationProduct(QuotationTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_QUOTATION_OLD_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuotationTable>> getOldQuotationProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_QUOTATION_OLD_PRODUCT);

    return List.generate(maps.length, (i) {
/*  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  double UnitRate;
  double Disc;
  double NetRate;
  double Amount;
  double TaxPer;
  double TaxAmount;
  double NetAmount;
  bool IsTaxType;
*/
      return QuotationTable(
        maps[i]['QuotationNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateOldQuotationProduct(QuotationTable model) async {
    final db = await database;

    await db.update(
      TABLE_QUOTATION_OLD_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteOldQuotationProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_QUOTATION_OLD_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLOldQuotationProduct() async {
    final db = await database;

    await db.delete(TABLE_QUOTATION_OLD_PRODUCT);
  }

  ///Here Quotation OtherCharge Table Implimentation

  Future<int> insertQuotationOtherCharge(QT_OtherChargeTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_QUOTATION_OTHERCHARGE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QT_OtherChargeTable>> getQuotationOtherCharge() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_QUOTATION_OTHERCHARGE_TABLE);

    return List.generate(maps.length, (i) {
      return QT_OtherChargeTable(
          maps[i]['Headerdiscount'],
          maps[i]['Tot_BasicAmt'],
          maps[i]['OtherChargeWithTaxamt'],
          maps[i]['Tot_GstAmt'],
          maps[i]['OtherChargeExcludeTaxamt'],
          maps[i]['Tot_NetAmount'],
          maps[i]['ChargeID1'],
          maps[i]['ChargeAmt1'],
          maps[i]['ChargeBasicAmt1'],
          maps[i]['ChargeGSTAmt1'],
          maps[i]['ChargeID2'],
          maps[i]['ChargeAmt2'],
          maps[i]['ChargeBasicAmt2'],
          maps[i]['ChargeGSTAmt2'],
          maps[i]['ChargeID3'],
          maps[i]['ChargeAmt3'],
          maps[i]['ChargeBasicAmt3'],
          maps[i]['ChargeGSTAmt3'],
          maps[i]['ChargeID4'],
          maps[i]['ChargeAmt4'],
          maps[i]['ChargeBasicAmt4'],
          maps[i]['ChargeGSTAmt4'],
          maps[i]['ChargeID5'],
          maps[i]['ChargeAmt5'],
          maps[i]['ChargeBasicAmt5'],
          maps[i]['ChargeGSTAmt5'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateQuotationOtherCharge(QT_OtherChargeTable model) async {
    final db = await database;

    await db.update(
      TABLE_QUOTATION_OTHERCHARGE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteQuotationOtherCharge(int id) async {
    final db = await database;

    await db.delete(
      TABLE_QUOTATION_OTHERCHARGE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLQuotationOtherCharge() async {
    final db = await database;

    await db.delete(TABLE_QUOTATION_OTHERCHARGE_TABLE);
  }

  ///Here Dealer Purchase Product Table Implimentation

  Future<int> insertDelaerPurchaseProduct(
      DealerPurchaseProductDBTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_DEALER_PURCHASE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DealerPurchaseProductDBTable>> getDelaerPurchaseProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_DEALER_PURCHASE_TABLE);

    return List.generate(maps.length, (i) {
/*  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  double UnitRate;
  double Disc;
  double NetRate;
  double Amount;
  double TaxPer;
  double TaxAmount;
  double NetAmount;
  bool IsTaxType;
*/
      return DealerPurchaseProductDBTable(
        maps[i]['QuotationNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateDelaerPurchaseProduct(
      DealerPurchaseProductDBTable model) async {
    final db = await database;

    await db.update(
      TABLE_DEALER_PURCHASE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteDelaerPurchaseProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_DEALER_PURCHASE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLDelaerPurchaseProduct() async {
    final db = await database;

    await db.delete(TABLE_DEALER_PURCHASE_TABLE);
  }

  /// Here DealerPurchaseOtherChargeTable Implimentation

  Future<int> insertDealerPurchaseOtherCharge(
      DealerPurchaseOtherChargeTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DealerPurchaseOtherChargeTable>>
      getDealerPurchaseOtherCharge() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE);

    return List.generate(maps.length, (i) {
      return DealerPurchaseOtherChargeTable(
          maps[i]['Headerdiscount'],
          maps[i]['Tot_BasicAmt'],
          maps[i]['OtherChargeWithTaxamt'],
          maps[i]['Tot_GstAmt'],
          maps[i]['OtherChargeExcludeTaxamt'],
          maps[i]['Tot_NetAmount'],
          maps[i]['ChargeID1'],
          maps[i]['ChargeAmt1'],
          maps[i]['ChargeBasicAmt1'],
          maps[i]['ChargeGSTAmt1'],
          maps[i]['ChargeID2'],
          maps[i]['ChargeAmt2'],
          maps[i]['ChargeBasicAmt2'],
          maps[i]['ChargeGSTAmt2'],
          maps[i]['ChargeID3'],
          maps[i]['ChargeAmt3'],
          maps[i]['ChargeBasicAmt3'],
          maps[i]['ChargeGSTAmt3'],
          maps[i]['ChargeID4'],
          maps[i]['ChargeAmt4'],
          maps[i]['ChargeBasicAmt4'],
          maps[i]['ChargeGSTAmt4'],
          maps[i]['ChargeID5'],
          maps[i]['ChargeAmt5'],
          maps[i]['ChargeBasicAmt5'],
          maps[i]['ChargeGSTAmt5'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateDealerPurchaseOtherCharge(
      DealerPurchaseOtherChargeTable model) async {
    final db = await database;

    await db.update(
      TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteDealerPurchaseOtherCharge(int id) async {
    final db = await database;

    await db.delete(
      TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLDealerPurchaseOtherCharge() async {
    final db = await database;

    await db.delete(TABLE_DEALER_PURCHASE_OTHERCHARGE_TABLE);
  }

  ///Here Dealer SaleBill Product Table Implimentation

  Future<int> insertDelaerSaleBillProduct(
      DealerSaleBillProductDBTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_DEALER_SALESBILL_PRODUCT_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DealerSaleBillProductDBTable>> getDelaerSaleBillProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_DEALER_SALESBILL_PRODUCT_TABLE);

    return List.generate(maps.length, (i) {
/*  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  double UnitRate;
  double Disc;
  double NetRate;
  double Amount;
  double TaxPer;
  double TaxAmount;
  double NetAmount;
  bool IsTaxType;
*/
      return DealerSaleBillProductDBTable(
        maps[i]['QuotationNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateDelaerSaleBillProduct(
      DealerSaleBillProductDBTable model) async {
    final db = await database;

    await db.update(
      TABLE_DEALER_SALESBILL_PRODUCT_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteDelaerSaleBillProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_DEALER_SALESBILL_PRODUCT_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLDelaerSaleBillProduct() async {
    final db = await database;

    await db.delete(TABLE_DEALER_SALESBILL_PRODUCT_TABLE);
  }

  /// Here DealerSaleBillOtherChargeTable Implimentation

  Future<int> insertDealerSaleBillOtherCharge(
      DealerSalesBillOtherChargeTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DealerSalesBillOtherChargeTable>>
      getDealerSaleBillOtherCharge() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE);

    return List.generate(maps.length, (i) {
      return DealerSalesBillOtherChargeTable(
          maps[i]['Headerdiscount'],
          maps[i]['Tot_BasicAmt'],
          maps[i]['OtherChargeWithTaxamt'],
          maps[i]['Tot_GstAmt'],
          maps[i]['OtherChargeExcludeTaxamt'],
          maps[i]['Tot_NetAmount'],
          maps[i]['ChargeID1'],
          maps[i]['ChargeAmt1'],
          maps[i]['ChargeBasicAmt1'],
          maps[i]['ChargeGSTAmt1'],
          maps[i]['ChargeID2'],
          maps[i]['ChargeAmt2'],
          maps[i]['ChargeBasicAmt2'],
          maps[i]['ChargeGSTAmt2'],
          maps[i]['ChargeID3'],
          maps[i]['ChargeAmt3'],
          maps[i]['ChargeBasicAmt3'],
          maps[i]['ChargeGSTAmt3'],
          maps[i]['ChargeID4'],
          maps[i]['ChargeAmt4'],
          maps[i]['ChargeBasicAmt4'],
          maps[i]['ChargeGSTAmt4'],
          maps[i]['ChargeID5'],
          maps[i]['ChargeAmt5'],
          maps[i]['ChargeBasicAmt5'],
          maps[i]['ChargeGSTAmt5'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateDealerSaleBillOtherCharge(
      DealerSalesBillOtherChargeTable model) async {
    final db = await database;

    await db.update(
      TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteDealerSaleBillOtherCharge(int id) async {
    final db = await database;

    await db.delete(
      TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLDealerSaleBillOtherCharge() async {
    final db = await database;

    await db.delete(TABLE_DEALER_SALESBILL_OTHERCHARGE_TABLE);
  }

  ///Here SalesBillProduct Table Implimentation

  Future<int> insertSalesBillProduct(SaleBillTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SALES_BILL_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SaleBillTable>> getSalesBillProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_SALES_BILL_PRODUCT);

    return List.generate(maps.length, (i) {
      return SaleBillTable(
        maps[i]['QuotationNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateSalesBillProduct(SaleBillTable model) async {
    final db = await database;

    await db.update(
      TABLE_SALES_BILL_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteSalesBillProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_SALES_BILL_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLSalesBillProduct() async {
    final db = await database;

    await db.delete(TABLE_SALES_BILL_PRODUCT);
  }

  ///Here SaleBill OtherCharge Table Implimentation

  Future<int> insertSalesBillOtherCharge(
      SaleBill_OtherChargeTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SALES_BILL_OTHERCHARGE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SaleBill_OtherChargeTable>> getSalesBillOtherCharge() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_SALES_BILL_OTHERCHARGE_TABLE);

    return List.generate(maps.length, (i) {
      return SaleBill_OtherChargeTable(
          maps[i]['Headerdiscount'],
          maps[i]['Tot_BasicAmt'],
          maps[i]['OtherChargeWithTaxamt'],
          maps[i]['Tot_GstAmt'],
          maps[i]['OtherChargeExcludeTaxamt'],
          maps[i]['Tot_NetAmount'],
          maps[i]['ChargeID1'],
          maps[i]['ChargeAmt1'],
          maps[i]['ChargeBasicAmt1'],
          maps[i]['ChargeGSTAmt1'],
          maps[i]['ChargeID2'],
          maps[i]['ChargeAmt2'],
          maps[i]['ChargeBasicAmt2'],
          maps[i]['ChargeGSTAmt2'],
          maps[i]['ChargeID3'],
          maps[i]['ChargeAmt3'],
          maps[i]['ChargeBasicAmt3'],
          maps[i]['ChargeGSTAmt3'],
          maps[i]['ChargeID4'],
          maps[i]['ChargeAmt4'],
          maps[i]['ChargeBasicAmt4'],
          maps[i]['ChargeGSTAmt4'],
          maps[i]['ChargeID5'],
          maps[i]['ChargeAmt5'],
          maps[i]['ChargeBasicAmt5'],
          maps[i]['ChargeGSTAmt5'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateSaleBillOtherCharge(
      SaleBill_OtherChargeTable model) async {
    final db = await database;

    await db.update(
      TABLE_SALES_BILL_OTHERCHARGE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteSaleBillOtherCharge(int id) async {
    final db = await database;

    await db.delete(
      TABLE_SALES_BILL_OTHERCHARGE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLSaleBillOtherCharge() async {
    final db = await database;

    await db.delete(TABLE_SALES_BILL_OTHERCHARGE_TABLE);
  }

  ///Here SalesORder Product Table Implimentation

  Future<int> insertSalesOrderProduct(SalesOrderTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SALES_ORDER_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SalesOrderTable>> getSalesOrderProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_SALES_ORDER_PRODUCT);

    return List.generate(maps.length, (i) {
      return SalesOrderTable(
        maps[i]['SalesOrderNo'],
        maps[i]['ProductSpecification'],
        maps[i]['ProductID'],
        maps[i]['ProductName'],
        maps[i]['Unit'],
        maps[i]['Quantity'],
        maps[i]['UnitRate'],
        maps[i]['DiscountPercent'],
        maps[i]['DiscountAmt'],
        maps[i]['NetRate'],
        maps[i]['Amount'],
        maps[i]['TaxRate'],
        maps[i]['TaxAmount'],
        maps[i]['NetAmount'],
        maps[i]['TaxType'],
        maps[i]['CGSTPer'],
        maps[i]['SGSTPer'],
        maps[i]['IGSTPer'],
        maps[i]['CGSTAmt'],
        maps[i]['SGSTAmt'],
        maps[i]['IGSTAmt'],
        maps[i]['StateCode'],
        maps[i]['pkID'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['BundleId'],
        maps[i]['HeaderDiscAmt'],
        maps[i]['DeliveryDate'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateSalesOrderProduct(SalesOrderTable model) async {
    final db = await database;

    await db.update(
      TABLE_SALES_ORDER_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteSalesOrderProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_SALES_ORDER_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLSalesOrderProduct() async {
    final db = await database;

    await db.delete(TABLE_SALES_ORDER_PRODUCT);
  }

  ///Here SalesOrder OtherCharge Table Implimentation

  Future<int> insertSalesOrderOtherCharge(SO_OtherChargeTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SALES_ORDER_OTHERCHARGE_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SO_OtherChargeTable>> getSalesOrderOtherCharge() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_SALES_ORDER_OTHERCHARGE_TABLE);

    return List.generate(maps.length, (i) {
      return SO_OtherChargeTable(
          maps[i]['Headerdiscount'],
          maps[i]['Tot_BasicAmt'],
          maps[i]['OtherChargeWithTaxamt'],
          maps[i]['Tot_GstAmt'],
          maps[i]['OtherChargeExcludeTaxamt'],
          maps[i]['Tot_NetAmount'],
          maps[i]['ChargeID1'],
          maps[i]['ChargeAmt1'],
          maps[i]['ChargeBasicAmt1'],
          maps[i]['ChargeGSTAmt1'],
          maps[i]['ChargeID2'],
          maps[i]['ChargeAmt2'],
          maps[i]['ChargeBasicAmt2'],
          maps[i]['ChargeGSTAmt2'],
          maps[i]['ChargeID3'],
          maps[i]['ChargeAmt3'],
          maps[i]['ChargeBasicAmt3'],
          maps[i]['ChargeGSTAmt3'],
          maps[i]['ChargeID4'],
          maps[i]['ChargeAmt4'],
          maps[i]['ChargeBasicAmt4'],
          maps[i]['ChargeGSTAmt4'],
          maps[i]['ChargeID5'],
          maps[i]['ChargeAmt5'],
          maps[i]['ChargeBasicAmt5'],
          maps[i]['ChargeGSTAmt5'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateSalesOrderOtherCharge(SO_OtherChargeTable model) async {
    final db = await database;

    await db.update(
      TABLE_SALES_ORDER_OTHERCHARGE_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteSalesOrderOtherCharge(int id) async {
    final db = await database;

    await db.delete(
      TABLE_SALES_ORDER_OTHERCHARGE_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLSalesOrderOtherCharge() async {
    final db = await database;

    await db.delete(TABLE_SALES_ORDER_OTHERCHARGE_TABLE);
  }

  /// Here Packing Product Assambly List Implimentation

  Future<int> insertPackingProductAssambly(
      PackingProductAssamblyTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PackingProductAssamblyTable>> getPackingProductAssambly() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE);

    return List.generate(maps.length, (i) {
      /* int id;
  String PCNo;
  int FinishProductID;
  String FinishProductName;
  int ProductGroupID;
  String ProductGroupName;
  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  String ProductSpecification;
  String Remarks;
  String LoginUserID;
  String CompanyId;*/
      return PackingProductAssamblyTable(
          maps[i]['PCNo'],
          maps[i]['FinishProductID'],
          maps[i]['FinishProductName'],
          maps[i]['ProductGroupID'],
          maps[i]['ProductGroupName'],
          maps[i]['ProductID'],
          maps[i]['ProductName'],
          maps[i]['Unit'],
          maps[i]['Quantity'],
          maps[i]['ProductSpecification'],
          maps[i]['Remarks'],
          maps[i]['LoginUserID'],
          maps[i]['CompanyId'],
          id: maps[i]['id']);
    });
  }

  Future<void> updatePackingProductAssambly(
      PackingProductAssamblyTable model) async {
    final db = await database;

    await db.update(
      TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deletePackingProductAssambly(int id) async {
    final db = await database;

    await db.delete(
      TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLPackingProductAssambly() async {
    final db = await database;

    await db.delete(TABLE_PACKING_PRODUCT_ASSAMBLY_TABLE);
  }

  /// Here Final Checking Items List Implimentaion

  Future<int> insertFinalCheckingItems(FinalCheckingItems model) async {
    final db = await database;

    return await db.insert(
      TABLE_FINAL_CHECKING_ITEM_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FinalCheckingItems>> getFinalCheckingItems() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_FINAL_CHECKING_ITEM_TABLE);

    return List.generate(maps.length, (i) {
      /*String CheckingNo;
  String CustomerID;
  String Item;
  String Checked;
  String Remarks;
  String SerialNo;
  String SRno;
  String LoginUserID;
  String CompanyId;*/
      return FinalCheckingItems(
          maps[i]['CheckingNo'],
          maps[i]['CustomerID'],
          maps[i]['Item'],
          maps[i]['Checked'],
          maps[i]['Remarks'],
          maps[i]['SerialNo'],
          maps[i]['SRno'],
          maps[i]['LoginUserID'],
          maps[i]['CompanyId'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateFinalCheckingItems(FinalCheckingItems model) async {
    final db = await database;

    await db.update(
      TABLE_FINAL_CHECKING_ITEM_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteFinalCheckingItems(int id) async {
    final db = await database;

    await db.delete(
      TABLE_FINAL_CHECKING_ITEM_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLFinalCheckingItems() async {
    final db = await database;

    await db.delete(TABLE_FINAL_CHECKING_ITEM_TABLE);
  }

  /// Sales_ORder PaymentSchedule CRUD/////
  Future<int> insertPaymentScheduleItems(SoPaymentScheduleTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SoPaymentScheduleTable>> getPaymentScheduleItems() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE);

    return List.generate(maps.length, (i) {
      return SoPaymentScheduleTable(
          maps[i]['Amount'], maps[i]['DueDate'], maps[i]['RevDueDate'],
          id: maps[i]['id']);
    });
  }

  Future<void> updatePaymentScheduleItems(SoPaymentScheduleTable model) async {
    final db = await database;

    await db.update(
        TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deletePaymentScheduleItem(int id) async {
    final db = await database;
    await db.delete(TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllPaymentScheduleItems() async {
    final db = await database;

    db.delete(TABLE_SALES_ORDER_PAYMENT_SCHEDULE_LIST_TABLE);
  }

  ///Here Customer Contact Table Implimentation

  Future<int> insertQuotationSpecificationTable(
      QuotationSpecificationTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_QUOTATION_SPECIFICATION_TABLE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuotationSpecificationTable>>
      getQuotationSpecificationTableList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_QUOTATION_SPECIFICATION_TABLE);

    return List.generate(maps.length, (i) {
      return QuotationSpecificationTable(
        maps[i]['OrderNo'],
        maps[i]['Group_Description'],
        maps[i]['Head'],
        maps[i]['Specification'],
        maps[i]['Material_Remarks'],
        maps[i]['QuotationNo'],
        maps[i]['ProductID'],
        id: maps[i]['id'],
      );
    });
  }

  Future<List<QuotationSpecificationTable>>
      getQuotationSpecificationWithProductID(String ProductID) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
        TABLE_QUOTATION_SPECIFICATION_TABLE,
        where: 'ProductID = ? ',
        whereArgs: [ProductID]);

    return List.generate(maps.length, (i) {
      return QuotationSpecificationTable(
        maps[i]['OrderNo'],
        maps[i]['Group_Description'],
        maps[i]['Head'],
        maps[i]['Specification'],
        maps[i]['Material_Remarks'],
        maps[i]['QuotationNo'],
        maps[i]['ProductID'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateQuotationSpecificationTable(
      QuotationSpecificationTable model) async {
    final db = await database;

    await db.update(
      TABLE_QUOTATION_SPECIFICATION_TABLE,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteQuotationSpecificationTable(int id) async {
    final db = await database;

    await db.delete(
      TABLE_QUOTATION_SPECIFICATION_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteQuotationSpecificationByFinishProductID(int id) async {
    final db = await database;

    await db.delete(
      TABLE_QUOTATION_SPECIFICATION_TABLE,
      where: 'ProductID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLQuotationSpecificationTable() async {
    final db = await database;

    await db.delete(TABLE_QUOTATION_SPECIFICATION_TABLE);
  }

  ///Generic Addional DB //
  ///DB Name : TABLE_GENERIC_ADDITIONAL_CHARGES
  ///Model Name : GenericAddditionalCharges
  Future<int> insertGenericAddditionalCharges(
      GenericAddditionalCharges model) async {
    final db = await database;

    return await db.insert(
      TABLE_GENERIC_ADDITIONAL_CHARGES,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GenericAddditionalCharges>> getGenericAddditionalCharges() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_GENERIC_ADDITIONAL_CHARGES);

    return List.generate(maps.length, (i) {
      return GenericAddditionalCharges(
        maps[i]['DiscountAmt'],
        maps[i]['ChargeID1'],
        maps[i]['ChargeAmt1'],
        maps[i]['ChargeID2'],
        maps[i]['ChargeAmt2'],
        maps[i]['ChargeID3'],
        maps[i]['ChargeAmt3'],
        maps[i]['ChargeID4'],
        maps[i]['ChargeAmt4'],
        maps[i]['ChargeID5'],
        maps[i]['ChargeAmt5'],
        maps[i]['ChargeName1'],
        maps[i]['ChargeName2'],
        maps[i]['ChargeName3'],
        maps[i]['ChargeName4'],
        maps[i]['ChargeName5'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateGenericAddditionalCharges(
      GenericAddditionalCharges model) async {
    final db = await database;

    await db.update(
      TABLE_GENERIC_ADDITIONAL_CHARGES,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteGenericAddditionalCharges(int id) async {
    final db = await database;

    await db.delete(
      TABLE_GENERIC_ADDITIONAL_CHARGES,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLGenericAddditionalCharges() async {
    final db = await database;

    await db.delete(TABLE_GENERIC_ADDITIONAL_CHARGES);
  }

  /// Quotation Assembly CRUD/////
  Future<int> insertQtAssemblyItems(QTAssemblyTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_QT_ASSEMBLY,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QTAssemblyTable>> getQtAssemblyItems(
      String FinishProductID) async {
    final db = await database;

    // final List<Map<String, dynamic>> maps = await db.query(TABLE_QT_ASSEMBLY);
    final List<Map<String, dynamic>> maps = await db.query(TABLE_QT_ASSEMBLY,
        where: 'FinishProductID = ? ', whereArgs: [FinishProductID]);
    return List.generate(maps.length, (i) {
      return QTAssemblyTable(
          maps[i]['FinishProductID'],
          maps[i]['ProductID'],
          maps[i]['ProductName'],
          maps[i]['Quantity'],
          maps[i]['Unit'],
          maps[i]['QuotationNo'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateQtAssemblyItems(QTAssemblyTable model) async {
    final db = await database;

    await db.update(TABLE_QT_ASSEMBLY, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteQtAssemblyItem(int id) async {
    final db = await database;
    await db.delete(TABLE_QT_ASSEMBLY, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllQtAssemblyItems() async {
    final db = await database;

    db.delete(TABLE_QT_ASSEMBLY);
  }

  /// SalesOrder Assembly CRUD TABLE_SO_ASSEMBLY

  Future<int> insertSOAssemblyItems(SOAssemblyTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SO_ASSEMBLY,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SOAssemblyTable>> getSOAssemblyItems(
      String FinishProductID) async {
    final db = await database;

    // final List<Map<String, dynamic>> maps = await db.query(TABLE_QT_ASSEMBLY);
    final List<Map<String, dynamic>> maps = await db.query(TABLE_SO_ASSEMBLY,
        where: 'FinishProductID = ? ', whereArgs: [FinishProductID]);
    return List.generate(maps.length, (i) {
      return SOAssemblyTable(
          maps[i]['FinishProductID'],
          maps[i]['ProductID'],
          maps[i]['ProductName'],
          maps[i]['Quantity'],
          maps[i]['Unit'],
          maps[i]['OrderNo'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateSOAssemblyItems(SOAssemblyTable model) async {
    final db = await database;

    await db.update(TABLE_SO_ASSEMBLY, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteSOAssemblyItem(int id) async {
    final db = await database;
    await db.delete(TABLE_SO_ASSEMBLY, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllSOAssemblyItems() async {
    final db = await database;

    db.delete(TABLE_SO_ASSEMBLY);
  }

  /// SalesBill Assembly CRUD TABLE_SB_ASSEMBLY SBAssemblyTable
  Future<int> insertSBAssemblyItems(SBAssemblyTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_SB_ASSEMBLY,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SBAssemblyTable>> getSBAssemblyItems(
      String FinishProductID) async {
    final db = await database;

    // final List<Map<String, dynamic>> maps = await db.query(TABLE_QT_ASSEMBLY);
    final List<Map<String, dynamic>> maps = await db.query(TABLE_SB_ASSEMBLY,
        where: 'FinishProductID = ? ', whereArgs: [FinishProductID]);
    return List.generate(maps.length, (i) {
      return SBAssemblyTable(
          maps[i]['FinishProductID'],
          maps[i]['ProductID'],
          maps[i]['ProductName'],
          maps[i]['Quantity'],
          maps[i]['Unit'],
          maps[i]['InvoiceNo'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateSBAssemblyItems(SBAssemblyTable model) async {
    final db = await database;

    await db.update(TABLE_SB_ASSEMBLY, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteSBAssemblyItem(int id) async {
    final db = await database;
    await db.delete(TABLE_SB_ASSEMBLY, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllSBAssemblyItems() async {
    final db = await database;

    db.delete(TABLE_SB_ASSEMBLY);
  }

  /// BlueTonProduct CRUD TABLE_BLUETON_PRODUCT SBAssemblyTable

  Future<int> insertBlueTonProductItems(BlueToneProductModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_BLUETON_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BlueToneProductModel>> getBlueTonProductList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_BLUETON_PRODUCT);

    return List.generate(maps.length, (i) {
      return BlueToneProductModel(
          maps[i]['InquiryNo'],
          maps[i]['LoginUserID'],
          maps[i]['CompanyId'],
          maps[i]['ProductName'],
          maps[i]['ProductID'],
          maps[i]['UnitPrice'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateBlueToneProductItems(BlueToneProductModel model) async {
    final db = await database;

    await db.update(TABLE_BLUETON_PRODUCT, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteBlueToneProductItem(int id) async {
    final db = await database;
    await db.delete(TABLE_BLUETON_PRODUCT, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllBlueToneProductItems() async {
    final db = await database;

    db.delete(TABLE_BLUETON_PRODUCT);
  }

  ///BlueTone Price CRUD
  Future<int> insertProductPriceList(PriceModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_BLUETON_PRICE,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PriceModel>> getProductPriceList(String FinishProductID) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_BLUETON_PRICE,
        where: 'ProductID = ? ', whereArgs: [FinishProductID]);
    return List.generate(maps.length, (i) {
      /* String ProductID;
  String ProductName;
  String SizeID;
  String SizeName;*/
      return PriceModel(maps[i]['ProductID'], maps[i]['ProductName'],
          maps[i]['SizeID'], maps[i]['SizeName'], maps[i]['isChecked'],
          id: maps[i]['id']);
    });
  }

  Future<List<PriceModel>> getAllProductPriceList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_BLUETON_PRICE);
    return List.generate(maps.length, (i) {
      /* String ProductID;
  String ProductName;
  String SizeID;
  String SizeName;*/
      return PriceModel(maps[i]['ProductID'], maps[i]['ProductName'],
          maps[i]['SizeID'], maps[i]['SizeName'], maps[i]['isChecked'],
          id: maps[i]['id']);
    });
  }

  Future<void> updateProductPriceItem(PriceModel model) async {
    final db = await database;

    await db.update(TABLE_BLUETON_PRICE, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteProductPriceList(String id) async {
    final db = await database;
    await db
        .delete(TABLE_BLUETON_PRICE, where: 'ProductID = ?', whereArgs: [id]);
  }

  Future<void> deleteAllProductPriceList() async {
    final db = await database;

    db.delete(TABLE_BLUETON_PRICE);
  }
}
