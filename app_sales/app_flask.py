from flask import Flask, render_template, request, jsonify

from models.model import Person, Supplier, Category, Brand, \
                            Product, Order, OrderDetail

app = Flask(__name__)

@app.route("/")

@app.route("/index")
def index():
    return render_template("index.html")

@app.route("/persons")
def persons():    
    return render_template("person.html", lst_persons = Person.generate_person())

@app.route("/suppliers")
def suppliers():
    return render_template("supplier.html", lst_suppliers = Supplier.generate_supplier())

@app.route("/categories")
def categories():
    return render_template("category.html", lst_categories = Category.generate_category())

@app.route("/brands")
def brands():
    return render_template("brand.html", lst_brands= Brand.generate_brand())

@app.route("/products")
def products():
    return render_template("product.html", lst_products = Product.generate_product())

@app.route("/orders")
def orders():
    return render_template("order.html", data_orders = Order.generate_order())

@app.route("/orders_by_supplier")
def orders_by_supplier():
    return render_template("ords_by_supplier.html", data_suppliers = Supplier.generate_ords_by_supplier())

@app.route("/prods_by_category")
def prods_by_category():
    return render_template("prods_by_category.html", data_categories = Product.generate_prods_by_category())


if __name__ == "__main__":
    app.run(debug = True)
