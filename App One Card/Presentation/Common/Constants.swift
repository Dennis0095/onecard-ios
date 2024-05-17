//
//  Constants.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

class Constants {
    static let placeholder_user: String = "Usuario digital"
    static let placeholder_password: String = "Clave digital"
    static let placeholder_name: String = "Nombres"
    static let placeholder_last_name: String = "Apellidos"
    static let placeholder_birthday: String = "Fecha de nacimiento"
    static let placeholder_phone: String = "Número de celular"
    static let placeholder_email: String = "Correo electrónico"
    static let accept: String = "Aceptar"
    static let login_btn: String = "Ingresar"
    static let login_register_btn: String = "¿Eres nuevo? Regístrate aquí"
    static let next_btn: String = "Continuar"
    static let placeholder_ruc: String = "RUC de la empresa donde trabajas"
    static let placeholder_document_number: String = "Número de documento"
    static let placeholder_document_type: String = "Tipo de documento"
    static let congratulations: String = "¡Felicidades!"
    static let congratulations_description: String = "Has creado tu nuevo usuario y clave digital con éxito."
    static let tab_title_home: String = "Inicio"
    static let tab_title_proms: String = "Promociones"
    static let tab_title_config: String = "Configuración"
    static let error: String = "Error"
    static let missingData: String = "Datos faltantes"
    
    static let OTP_SHIPPING_SMS: String = "1"
    static let OTP_SHIPPING_EMAIL: String = "2"
    
    //MARK: Login error
    static let login_error_incomplete_data: String = "Por favor, ingresa todos los datos solicitados."
    
    //MARK: Keys User Defaults
    static let keyToken = "token"
    static let keyUser = "user"
    static let keyCardStatus = "cardStatus"
    static let keyLinkRegister = "linkRegister"
    static let keyLinkDataTreatment = "linkDataTreatment"
    static let keyLinkRecovery = "linkRecovery"
    
    static let dni = "DNI"
    static let passport = "PASAPORTE"
    static let ruc = "RUC"
    static let ptp = "PTP"
    static let immigration_card = "CARNET DE EXTRANJERÍA"
    static let dni_id = "1"
    static let passport_id = "3"
    static let ruc_id = "5"
    static let ptp_id = "7"
    static let immigration_card_id = "2"
    
    static let defaultLink = "www.google.com"
}
