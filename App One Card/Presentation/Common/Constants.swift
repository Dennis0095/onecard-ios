//
//  Constants.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

class Constants {
    static let welcome_male: String = "BIENVENIDO"
    static let welcome_female: String = "BIENVENIDA"
    static let placeholder_user: String = "Usuario"
    static let placeholder_digital_user: String = "Usuario digital"
    static let confirm_your_digital_key: String = "Confirma tu clave digital"
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
    static let cancel: String = "Cancelar"
    static let close_session: String = "Cerrar sesión"
    static let activate: String = "Activar"
    static let i_will_later: String = "Lo haré luego"
    static let activate_card: String = "Activar Tarjeta"
    static let you_sure_male: String = "¿Estás seguro de que deseas bloquear tu tarjeta ONE CARD?"
    static let you_sure_female: String = "¿Estás segura de que deseas bloquear tu tarjeta ONE CARD?"
    static let you_sure_logout_male: String = "¿Estás seguro de que deseas cerrar sesión?"
    static let you_sure_logout_female: String = "¿Estás segura de que deseas cerrar sesión?"
    static let try_again: String = "Volver a intentar"
    static let apply_filters: String = "Aplicar filtros"
    static let clear_filters: String = "Borrar filtros"
    
    static let OTP_SHIPPING_SMS: String = "1"
    static let OTP_SHIPPING_EMAIL: String = "2"
    
    //MARK: Login error
    static let login_error_incomplete_data: String = "Por favor, ingresa todos los datos solicitados."
    
    static let user_is_in_use = "El usuario está en uso"
    static let please_choose_another_username = "Por favor, elige otro nombre de usuario."
    
    static let must_contain_between_9_to_12_numbers = "Debe contener entre 9 a 12 números"
    static let must_contain_8_numbers = "Debe contener 8 números"
    static let enter_immigration_card = "Ingresa tu carnet de extranjería"
    static let enter_dni = "Ingresa tu número de documento"
    static let enter_ruc = "Ingresa el RUC de la empresa donde trabajas"
    static let enter_your_ruc = "Ingresa tu RUC"
    static let dni = "DNI"
    static let dni_placeholder = "Número de documento"
    static let passport = "PASAPORTE"
    static let passport_placeholder = "Pasaporte"
    static let ruc = "RUC"
    static let ruc_placeholder = "RUC"
    static let ptp = "PTP"
    static let ptp_placeholder = "Permiso temporal de permanencia"
    static let immigration_card = "CARNET DE EXTRANJERÍA"
    static let immigration_card_placeholder = "Carnet de extranjería"
    static let dni_id = "1"
    static let immigration_card_id = "2"
    static let passport_id = "3"
    static let ruc_id = "5"
    static let ptp_id = "7"
    
    static let defaultLink = "www.google.com"
    
    static let user_recovery_operation_type = "OU"
    
    static let end_time = 180
    static let question_time = 140
    static let time_left = (end_time - question_time)
    
    //MARK: Keys User Defaults
    static let keyToken = "token"
    static let keyUser = "user"
    static let keyPromotionCategories = "promotionCategories"
    static let keyCardStatus = "cardStatus"
    static let keyLinkRegister = "linkRegister"
    static let keyLinkDataTreatment = "linkDataTreatment"
    static let keyLinkRecovery = "linkRecovery"
}
