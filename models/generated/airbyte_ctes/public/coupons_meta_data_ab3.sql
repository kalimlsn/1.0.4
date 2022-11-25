{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('coupons_meta_data_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_coupons_hashid',
        adapter.quote('id'),
        adapter.quote('key'),
        object_to_string(adapter.quote('value')),
    ]) }} as _airbyte_meta_data_hashid,
    tmp.*
from {{ ref('coupons_meta_data_ab2') }} tmp
-- meta_data at coupons/meta_data
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

