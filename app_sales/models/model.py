# models

from typing import List
from models.mysqldb import mysql_cnn

# class Person

class Person:

    # constructor for class person
    def __init__(self, p_id, p_name, p_email, c_company, tp_type):
        self.id = p_id
        self.name = p_name
        self.email = p_email
        self.company = c_company
        self.type = tp_type

    # list person
    def list_person():        
        mysql_cnn.connect()
        query = "select * from vw_person"
        res = mysql_cnn.execute_query(query)        
        mysql_cnn.close()

        return res

    # generate JSON structure for person
    def generate_person():
        data = []        
        for row in Person.list_person():
            data.append({
                'id': row[0],
                'name': row[1],
                'email': row[2],
                'company': row[3],
                'type': row[4]
            })
        
        return data
    
    # insert person
    def insert_person(self):
        mysql_cnn.connect()
        procedure = "sp_person_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.name, self.email, 
                                           self.company, self.type)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table person")
        elif res == 0:
            print("data not inserted")

    # edit person
    def edit_person(self):
        mysql_cnn.connect()
        procedure = "sp_person_edit"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.name, self.email, 
                                           self.company, self.type)
        mysql_cnn.close()

        if res == 1:
            print("data successfully edited in table person")
        elif res == 0:
            print("data not edited")


# class Supplier

class Supplier:

    # constructor for class supplier
    def __init__(self, p_id, s_status):
        self.id = p_id
        self.status = s_status

    # list supplier
    def list_supplier():
        mysql_cnn.connect()
        query = "select * from vw_supplier"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON struct for supplier
    def generate_supplier():
        data = []
        for row in Supplier.list_supplier():
            data.append({
                'id': row[0],
                'name': row[1],
                'status': row[2],
                'num_orders': row[3],
                'acc_orders': row[4]
            })
        
        return data

    # insert supplier
    def insert_supplier(self):
        mysql_cnn.connect()
        procedure = "sp_supplier_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.status)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table supplier")
        elif res == 0:
            print("data not inserted")
    
    # edit supplier
    def edit_supplier(self):
        mysql_cnn.connect()
        procedure = "sp_supplier_edit"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.status)
        mysql_cnn.close()

        if res == 1:
            print("data successfully edited in table supplier")
        elif res == 0:
            print("data not edited")

    # list orders by supplier
    def list_ord_by_supplier(s_id):
        mysql_cnn.connect()
        procedure = "sp_ord_by_supplier"
        res = mysql_cnn.execute_procedure_query(procedure, s_id)
        mysql_cnn.close()

        return res

    # generate JSON struct for orders by supplier
    def generate_ords_by_supplier():
        data = []

        for sup in Supplier.list_supplier():
            ords = []
            s_id = sup[0]

            data.append({
                'id': sup[0],
                'name': sup[1],
                'status': sup[2],
                'num_orders': sup[3],
                'accumulate': sup[4],
                'orders': ords
            })

            ls_ords = Supplier.list_ord_by_supplier(s_id)

            # print the orders by each supplier
            if ls_ords:
                for ord in ls_ords:
                    ords.append({
                        'date': ord[0],
                        'id': ord[1],
                        'total': ord[2]                        
                    })            

        return data

    # print orders by supplier
    def print_ord_by_supplier():
        print(" --- List of orders by supplier --- ")
        
        # print each supplier
        for sup in Supplier.list_supplier():
            s_id = sup[0]
            print(f"Register of orders for supplier {sup[1]}: ")
            print(f"Status = {sup[2]} | Num-orders = {sup[3]} | Accumulate = $ {sup[4]}")
            print("-------------------------------------------------------------")

            ls_ords = Supplier.list_ord_by_supplier(s_id)

            # print the orders by each supplier
            if ls_ords:
                for ord in ls_ords:
                    print(f"date: {ord[0]}   ---  "
                          f"order-id: {ord[1]} ==> total = $ {ord[2]}")
            else:
                print(f"Supplier {sup[1]} doesnt made orders")


# class Category

class Category:

    # constructor for class category
    def __init__(self, c_id, c_name):
        self.id = c_id
        self.name = c_name

    # list category
    def list_category():
        mysql_cnn.connect()
        query = "select * from vw_category"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for category
    def generate_category():
        data = []
        for row in Category.list_category():
            data.append({
                'id': row[0],
                'name': row[1]
            })

        return data
    
    # insert category
    def insert_category(self):
        mysql_cnn.connect()
        procedure = "sp_category_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.name)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table category")
        elif res == 0:
            print("data not inserted")

    # edit category
    def edit_category(self):
        mysql_cnn.connect()
        procedure = "sp_category_edit"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.name)
        mysql_cnn.close()

        if res == 1:
            print("data successfully edited in table category")
        elif res == 0:
            print("data not edited")

# class Brand

class Brand:
    
    # constructor for class brand
    def __init__(self, b_id, b_name, b_date_creation):
        self.id = b_id
        self.name = b_name
        self.date_creation = b_date_creation

    # list brand
    def list_brand():
        mysql_cnn.connect()
        query = "select * from vw_brand"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for brand
    def generate_brand():
        data = []
        for row in Brand.list_brand():
            data.append({
                'id': row[0],
                'name': row[1],
                'date_creation': row[2]
            })

        return data
    
    # insert brand
    def insert_brand(self):
        mysql_cnn.connect()
        procedure = "sp_brand_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.name, self.date_creation)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table brand")
        elif res == 0:
            print("data not inserted")

    # edit brand
    def edit_brand(self):
        mysql_cnn.connect()
        procedure = "sp_brand_edit"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.name, self.date_creation)
        mysql_cnn.close()

        if res == 1:
            print("data successfully edited in table brand")
        elif res == 0:
            print("data not edited")

# class Product

class Product:

    # constructor for class Product
    def __init__(self, p_id, p_bar_code, p_name, p_description, p_unit_price,
                 c_category, b_brand):
        self.id = p_id
        self.bar_code = p_bar_code
        self.name = p_name
        self.description = p_description
        self.unit_price = p_unit_price
        self.category = c_category
        self.brand = b_brand

    # list product
    def list_product():
        mysql_cnn.connect()
        query = "select * from vw_product"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # generate JSON structure for product
    def generate_product():
        data = []
        for row in Product.list_product():
            data.append({
                'id': row[0],
                'bar_code': row[1],
                'prod_name': row[2],
                'category': row[3],
                'brand': row[4],
                'description': row[5],
                'unit_price': row[6]
            })

        return data

    # insert product
    def insert_product(self):
        mysql_cnn.connect()
        procedure = "sp_product_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.bar_code, self.name,
                    self.description, self.unit_price, self.category, self.brand)
        mysql_cnn.close()

        if res == 1:
            print("data successfully inserted in table product")
        elif res == 0:
            print("data not inserted")

    # edit product
    def edit_product(self):
        mysql_cnn.connect()
        procedure = "sp_product_edit"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.bar_code, self.name,
                    self.description, self.unit_price, self.category, self.brand)
        mysql_cnn.close()

        if res == 1:
            print("data successfully edited in table product")
        elif res == 0:
            print("data not edited")

    # list products by category
    def list_prod_by_category(c_id):
        mysql_cnn.connect()
        procedure = "sp_prod_by_category"
        res = mysql_cnn.execute_procedure_query(procedure, c_id)
        mysql_cnn.close()

        return res

    # generate JSON struct for products by category
    def generate_prods_by_category():
        data = []

        for cat in Category.list_category():
            prods = []
            c_id = cat[0]            

            data.append({
                'id': cat[0],
                'name': cat[1],
                'products': prods
            })

            ls_prods = Product.list_prod_by_category(c_id)

            if ls_prods:
                for prod in ls_prods:
                    prods.append({
                        'id': prod[0],
                        'name': prod[1],
                        'unit_price': prod[2]
                    })
        
        return data

    # print products by category
    def print_prod_by_category():
        print(" --- List of products by category --- ")

        # print each category
        for cat in Category.list_category():
            c_id = cat[0]
            print(f"id-category: {cat[0]} | category: {cat[1]}")
            print("Products: ")
            print("-----------------------------------------------")            

            ls_prod = Product.list_prod_by_category(c_id)
            
            # print products related for each category
            if ls_prod:
                for prod in ls_prod:
                    print(f"product-{prod[0]} ==> name: {prod[1]} | unit-price: $ {prod[2]}")
            else:
                print(f"category {cat[1]} doesnt have products")


# class Order Detail

class OrderDetail:

    # constructor for class Orderdetail
    def __init__(self, o_id, p_id, od_quantity):
        self.order = o_id
        self.product = p_id
        self.quantity = od_quantity        

    # list orderdetail
    def list_details(id_order):
        mysql_cnn.connect()
        procedure = "sp_details_by_order"
        res = mysql_cnn.execute_procedure_query(procedure, id_order)
        mysql_cnn.close()

        return res

    # insert orderdetail
    def insert_details(self):
        mysql_cnn.connect()
        procedure = "sp_detail_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.order,
                    self.product, self.quantity)
        mysql_cnn.close()

        return res

# class Order

class Order:

    # constructor for class Order
    def __init__(self, o_id, s_id, details: List["OrderDetail"]):
        self.id = o_id        
        self.supplier = s_id
        self.details = details        

    # list orders
    def list_orders():
        mysql_cnn.connect()
        query = "select * from vw_order"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        return res

    # show accumullate for all orders
    def show_accumulate_ords():
        mysql_cnn.connect()
        query = "select * from vw_total_orders"
        res = mysql_cnn.execute_query(query)
        mysql_cnn.close()

        for row in res:
            acc = row[0]
        
        return acc
    
    # insert orders with details
    def insert_order(self):
        mysql_cnn.connect()
        procedure = "sp_order_insert"
        res = mysql_cnn.execute_sprocedure(procedure, self.id, self.supplier)
        mysql_cnn.close()

        if res == 1:
            if self.details:
                items = 0
                for detail in self.details:                
                    items += 1
                    OrderDetail(detail.order, detail.product, detail.quantity).insert_details()
                print(f"Order inserted with {items} items")
            else:
                print("The order doesnt have details")
        else:
            print("Order not inserted")

    # generate JSON structure for order
    def generate_order():
        ords = []
        for row in Order.list_orders():
            ords.append({
                'id': row[0],
                'date_generated': row[1],
                'supplier': row[2],
                'total': row[3]
            })

        data = {
            'lst_orders': ords,
            'acc_all_ords': Order.show_accumulate_ords()
        } 

        return data

    # print orders
    def print_orders():
        print(" --- List of orders --- ")

        for ord in Order.list_orders():
            print(f"id-order: {ord[0]} | date-generated: {ord[1]} | "
                  f"supplier: {ord[2]} | total: {ord[3]}")

    # generate JSON structure for details by order
    def generate_details_by_order():
        ords = []

        for ord in Order.list_orders():
            o_id = ord[0]
            items = []

            ords.append({
                'id': ord[0],
                'date_generated': ord[1],
                'supplier': ord[2],
                'details': items,
                'total': ord[3]
            })

            ls_details = OrderDetail.list_details(o_id)
            i = 0

            if ls_details:
                for item in ls_details:
                    i +=1
                    items.append({
                        'num_item': i,
                        'product': item[0],
                        'unit_price': item[1],
                        'quantity': item[2],
                        'subtotal': item[3]
                    })

        data = {
            'lst_orders': ords,
            'acc_all_orders': Order.show_accumulate_ords()
        }

        return data

    # print details by order
    def print_details_by_order():
        print(" --- List of orders with items --- ")

        for ord in Order.list_orders():
            o_id = ord[0]
            print(f"id-order: {ord[0]} | date-generated: {ord[1]} | "
                  f"supplier: {ord[2]}")
            print("Order Detail:")
            print("-------------------------------------------------------")
            
            ls_details = OrderDetail.list_details(o_id)
            
            i = 0
            if ls_details:
                for item in ls_details:
                    i += 1
                    print(f"Item {i} ==> Product: {item[0]} | "
                          f"Unit-price: {item[1]} | Qty: {item[2]} | "
                          f"Subtotal: $ {item[3]}")
            print(f"Total for order {ord[0]}: -------------------------------------- $ {ord[3]}")
        print(f"Accumulate for all orders: ---------------------------------------------------- "
              f"$ {Order.show_accumulate_ords()}")

