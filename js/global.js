

function toggle(obj) {
	var el = document.getElementById(obj);
	el.style.display = (el.style.display != 'none' ? 'none' : '' );
}

function isPhoneNumber(str){
  var re = /^\(?([2-9]{1}[0-9]{2})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;

  return re.test(str);
}

function formatPhone(str) {
	 var re = /^\(?([2-9]{1}[0-9]{2})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
	
	return str.replace(re, "($1) $2-$3");

}

function isName(str){
  var re = /^[a-zA-Z\.\,\-\s']*$/;
  return re.test(str);
}


function valCheckoutSubmit() {

	var name = document.getElementById("contact");
	var phone = document.getElementById("phone");
	var errID = document.getElementById("errMsg");
	
	var errMsg = "";
	
	
	if(!isName(name.value) || !name.value.length){
		errMsg += "Name is not Valid<br />";
	}
	
	if(!isPhoneNumber(phone.value)){
		errMsg += "Phone is not Valid<br />";
	} else {
		phone.value = formatPhone(phone.value);
	}
	
	if(errMsg.length) {	
		errID.style.display = "block";
		errID.innerHTML  = errMsg;
		return false;
	}

	errID.style.display = "none";
	errID.innerHTML  = errMsg;
	return true;
}


function confirmSubmit() {
	var agree=confirm("Are you sure you wish to continue?");
	if (agree)
		return true;
	else
		return false;
}


function addToQty(){

	var Field = document.getElementById("Quantity");
	
	var Fieldvalue = parseInt(Field.value);
	
	if(Fieldvalue >= 0) {
		Field.value = parseInt(Fieldvalue+1);		
	}

	CalculateOrderTotal();

}

function subToQty(){
	var Field = document.getElementById("Quantity");
	
	var Fieldvalue = parseInt(Field.value);

	if(Fieldvalue > 1) {
		Field.value = parseInt(Fieldvalue-1);		
	} else {
		Field.value = 1;
	}
	
	CalculateOrderTotal();
}




//Define function to format a value as currency:
	function formatCurrency(num)
	{
	   // Courtesy of http://www7.brinkster.com/cyanide7/
		num = num.toString().replace(/\$|\,/g,'');
		if(isNaN(num))
		   num = "0";
		sign = (num == (num = Math.abs(num)));
		num = Math.floor(num*100+0.50000000001);
		cents = num%100;
		num = Math.floor(num/100).toString();
		if(cents<10)
		    cents = "0" + cents;
		for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
		    num = num.substring(0,num.length-(4*i+3))+''+
		          num.substring(num.length-(4*i+3));
  	    return (((sign)?'':'-') + num + '.' + cents);
	}


function getQuantityPrice() {

	var Field = document.getElementById("Quantity");
	var Fieldvalue = parseInt(Field.value);
	
	return parseFloat(Fieldvalue*pizzaAmt);
}

function getToppingsPrice() {

	var len = toppingIDs.length;
	var order_total = 0;
		
	for (x in toppingIDs) {
	
		 if (toppingIDs.hasOwnProperty(x) )	{
			var Field = document.getElementById(x);
			if(Field)
				order_total = parseFloat(order_total+parseFloat(Field.options[Field.selectedIndex].value*toppingIDs[x]));
	    }
	
	}
		
	return parseFloat(order_total);
}
	
	
function CalculateOrderTotal() {

	var priceField = document.getElementById("price");
    var order_total = parseFloat(getQuantityPrice()+getToppingsPrice());
    priceField.value = formatCurrency(order_total);
}



function valLookupSubmit(){

	var Field = document.getElementById("LookupOrderID");
	var Fieldvalue = Field.value.replace(/^\s+|\s+$/g,""); //trim white space
	var errID = document.getElementById("errMsg");	
	var errMsg = "";
	
		
	if(!Fieldvalue.length || Fieldvalue == "") {
		errMsg += "Please Enter a Order ID<br />";	
	}
	
	if(errMsg.length) {	
		errID.style.display = "block";
		errID.innerHTML  = errMsg;
		return false;
	}

	errID.style.display = "none";
	errID.innerHTML  = errMsg;
	return true;
	
}


function attachOnSubmitHandler(){

	var elms = document.getElementsByName("delete");	
	var i = elms.length;
	
	while(i--) {
		var thisElm = elms[i];
		if("tagName" in thisElm && thisElm.tagName == "FORM") {
			thisElm.onsubmit = function(){return confirmSubmit();}
		}	
	}
	
	elms = document.getElementsByName("finish");	
	i = elms.length;
	
	while(i--) {
		var thisElm = elms[i];
		if("tagName" in thisElm && thisElm.tagName == "FORM") {
			thisElm.onsubmit = function(){return valCheckoutSubmit();}
		}	
	}
	
	elms = document.getElementsByName("addOrder");	
	i = elms.length;
	
	while(i--) {
		var thisElm = elms[i];
		if("tagName" in thisElm && thisElm.tagName == "FORM") {
			thisElm.onsubmit = function(){ CalculateOrderTotal();}
		}	
	}
	
	elms = document.getElementsByName("lookup");	
	i = elms.length;
	
	while(i--) {
		var thisElm = elms[i];
		if("tagName" in thisElm && thisElm.tagName == "FORM") {
			thisElm.onsubmit = function(){ return valLookupSubmit();}
		}	
	}
	

}



attachOnSubmitHandler();
