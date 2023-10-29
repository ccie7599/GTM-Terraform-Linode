resource "akamai_gtm_property" "property" {
  domain                      = akamai_gtm_domain.domain.name
  name                        = var.property
  type                        = "performance"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 30
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  load_imbalance_percentage   = 1200
  ghost_demand_reporting      = false

  liveness_test {
    name                             = "TCP"
    peer_certificate_verification    = false
    test_interval                    = 10
    test_object                      = ""
    http_error3xx                    = true
    http_error4xx                    = true
    http_error5xx                    = true
    disabled                         = false
    test_object_protocol             = "TCP"
    test_object_port                 = 80
    disable_nonstandard_port_warning = false
    test_timeout                     = 10
    answers_required                 = false
    recursion_requested              = false
  }

  traffic_target {
    datacenter_id = akamai_gtm_datacenter.fr-par.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["172.233.254.152"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.in-maa.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["172.232.112.251"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.jp-osa.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["172.233.67.162","172.233.82.110"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-iad.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["139.144.209.110"]
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-lax.datacenter_id
    enabled       = true
    weight        = 0
    servers       = ["172.233.152.172"]
  }
}
