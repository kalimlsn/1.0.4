{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('orders_coupon_lines_meta_data_ab3') }}
select
    _airbyte_coupon_lines_hashid,
    {{ adapter.quote('id') }},
    {{ adapter.quote('key') }},
    {{ adapter.quote('value') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_meta_data_hashid
from {{ ref('orders_coupon_lines_meta_data_ab3') }}
-- meta_data at orders/coupon_lines/meta_data from {{ ref('orders_coupon_lines') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

