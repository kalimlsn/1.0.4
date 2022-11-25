{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('coupons__links_ab3') }}
select
    _airbyte_coupons_hashid,
    {{ adapter.quote('self') }},
    collection,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte__links_hashid
from {{ ref('coupons__links_ab3') }}
-- _links at coupons/_links from {{ ref('coupons_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

