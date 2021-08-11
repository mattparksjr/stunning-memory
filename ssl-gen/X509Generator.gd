#######################################
# Name: X509Generator
# Author: Matthew
# Desc: Generates a ssl certificate 
#       with x509 encryption
#######################################
extends Node

# File names
var cert_fname = "cert.crt"
var key_fname = "key.key"

# File paths
onready var cert_path = "user://certificate/" + cert_fname
onready var key_path = "user://certificate/" + key_fname

# Variables
var CN = "SaucePot"
var O = "TMFB"
var C = "US"

# Creates dir, starts cert
func _ready():
	var dict = Directory.new()
	if dict.dir_exists("user://certificate/"):
		pass
	else:
		dict.make_dir("user://certificate/")
	create_cert()
	print("Cert generated")

# Does the real work
func create_cert():
	var CNOC = "CN=" + CN + ",O=" + O + ",C=" + C
	var crypto = Crypto.new()
	var c_key = crypto.generate_rsa(4096)
	var X509_cert = crypto.generate_self_signed_certificate(c_key, CNOC)
	X509_cert.save(cert_path)
	c_key.save(key_path)
