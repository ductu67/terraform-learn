output "load_balancer_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "database.endpoint" {
  value = module.database.endpoint
}