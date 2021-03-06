(define (problem p6_hosts_trial_6)
(:domain caldera-split)
(:objects
    id_cifile - observedfile
    id_clfile - observedfile
    id_cgfile - observedfile
    id_ckfile - observedfile
    id_chfile - observedfile
    id_cjfile - observedfile
    str__bo - string
    str__cb - string
    str__i - string
    str__s - string
    str__james - string
    str__j - string
    str__bv - string
    str__bi - string
    str__t - string
    str__b - string
    str__ba - string
    str__z - string
    str__n - string
    str__e - string
    str__john - string
    str__cf - string
    str__bh - string
    str__cd - string
    str__bw - string
    str__bg - string
    str__mary - string
    str__m - string
    str__bp - string
    str__u - string
    str__bb - string
    str__alpha - string
    str__f - string
    str__bu - string
    str__bn - string
    str__cc - string
    id_adomain - observeddomain
    id_bytimedelta - observedtimedelta
    id_brtimedelta - observedtimedelta
    id_bdtimedelta - observedtimedelta
    id_wtimedelta - observedtimedelta
    id_bktimedelta - observedtimedelta
    id_ptimedelta - observedtimedelta
    id_ohost - observedhost
    id_bjhost - observedhost
    id_bqhost - observedhost
    id_vhost - observedhost
    id_bxhost - observedhost
    id_bchost - observedhost
    num__31 - num
    num__45 - num
    num__30 - num
    num__17 - num
    num__38 - num
    num__44 - num
    num__23 - num
    num__24 - num
    num__37 - num
    num__51 - num
    num__52 - num
    num__16 - num
    id_crschtask - observedschtask
    id_cmschtask - observedschtask
    id_coschtask - observedschtask
    id_cnschtask - observedschtask
    id_cpschtask - observedschtask
    id_cqschtask - observedschtask
    id_cxrat - observedrat
    id_cwrat - observedrat
    id_cerat - observedrat
    id_ctrat - observedrat
    id_curat - observedrat
    id_csrat - observedrat
    id_cvrat - observedrat
    id_ddshare - observedshare
    id_dashare - observedshare
    id_dcshare - observedshare
    id_cyshare - observedshare
    id_dbshare - observedshare
    id_czshare - observedshare
    id_gdomainuser - observeddomainuser
    id_kdomainuser - observeddomainuser
    id_cdomainuser - observeddomainuser
    id_ldomaincredential - observeddomaincredential
    id_hdomaincredential - observeddomaincredential
    id_ddomaincredential - observeddomaincredential
)
(:init
    (knows id_cerat)
    (knows id_vhost)
    (knows_property id_cerat pexecutable)
    (knows_property id_cerat phost)
    (knows_property id_vhost pfqdn)
    (MEM_CACHED_DOMAIN_CREDS id_bchost id_ddomaincredential)
    (MEM_CACHED_DOMAIN_CREDS id_bjhost id_hdomaincredential)
    (MEM_CACHED_DOMAIN_CREDS id_bqhost id_ldomaincredential)
    (MEM_CACHED_DOMAIN_CREDS id_bxhost id_hdomaincredential)
    (MEM_CACHED_DOMAIN_CREDS id_ohost id_ddomaincredential)
    (MEM_CACHED_DOMAIN_CREDS id_vhost id_ddomaincredential)
    (MEM_DOMAIN_USER_ADMINS id_bchost id_gdomainuser)
    (MEM_DOMAIN_USER_ADMINS id_bjhost id_kdomainuser)
    (MEM_DOMAIN_USER_ADMINS id_bqhost id_gdomainuser)
    (MEM_DOMAIN_USER_ADMINS id_bxhost id_cdomainuser)
    (MEM_DOMAIN_USER_ADMINS id_ohost id_kdomainuser)
    (MEM_DOMAIN_USER_ADMINS id_vhost id_cdomainuser)
    (mem_hosts id_adomain id_bchost)
    (mem_hosts id_adomain id_bjhost)
    (mem_hosts id_adomain id_bqhost)
    (mem_hosts id_adomain id_bxhost)
    (mem_hosts id_adomain id_ohost)
    (mem_hosts id_adomain id_vhost)
    (prop_cred id_cdomainuser id_ddomaincredential)
    (prop_cred id_gdomainuser id_hdomaincredential)
    (prop_cred id_kdomainuser id_ldomaincredential)
    (PROP_DC id_bchost no)
    (PROP_DC id_bjhost no)
    (PROP_DC id_bqhost yes)
    (PROP_DC id_bxhost no)
    (PROP_DC id_ohost yes)
    (PROP_DC id_vhost yes)
    (PROP_DNS_DOMAIN id_adomain str__b)
    (PROP_DNS_DOMAIN_NAME id_bchost str__bg)
    (PROP_DNS_DOMAIN_NAME id_bjhost str__bn)
    (PROP_DNS_DOMAIN_NAME id_bqhost str__bu)
    (PROP_DNS_DOMAIN_NAME id_bxhost str__cb)
    (PROP_DNS_DOMAIN_NAME id_ohost str__s)
    (PROP_DNS_DOMAIN_NAME id_vhost str__z)
    (PROP_DOMAIN id_bchost id_adomain)
    (PROP_DOMAIN id_bjhost id_adomain)
    (PROP_DOMAIN id_bqhost id_adomain)
    (PROP_DOMAIN id_bxhost id_adomain)
    (PROP_DOMAIN id_cdomainuser id_adomain)
    (PROP_DOMAIN id_ddomaincredential id_adomain)
    (PROP_DOMAIN id_gdomainuser id_adomain)
    (PROP_DOMAIN id_hdomaincredential id_adomain)
    (PROP_DOMAIN id_kdomainuser id_adomain)
    (PROP_DOMAIN id_ldomaincredential id_adomain)
    (PROP_DOMAIN id_ohost id_adomain)
    (PROP_DOMAIN id_vhost id_adomain)
    (prop_elevated id_cerat yes)
    (prop_executable id_cerat str__cf)
    (PROP_FQDN id_bchost str__bh)
    (PROP_FQDN id_bjhost str__bo)
    (PROP_FQDN id_bqhost str__bv)
    (PROP_FQDN id_bxhost str__cc)
    (PROP_FQDN id_ohost str__t)
    (PROP_FQDN id_vhost str__ba)
    (prop_host id_bdtimedelta id_bchost)
    (prop_host id_bktimedelta id_bjhost)
    (prop_host id_brtimedelta id_bqhost)
    (prop_host id_bytimedelta id_bxhost)
    (prop_host id_cerat id_vhost)
    (prop_host id_ptimedelta id_ohost)
    (prop_host id_wtimedelta id_vhost)
    (PROP_HOSTNAME id_bchost str__bi)
    (PROP_HOSTNAME id_bjhost str__bp)
    (PROP_HOSTNAME id_bqhost str__bw)
    (PROP_HOSTNAME id_bxhost str__cd)
    (PROP_HOSTNAME id_ohost str__u)
    (PROP_HOSTNAME id_vhost str__bb)
    (PROP_IS_GROUP id_cdomainuser no)
    (PROP_IS_GROUP id_gdomainuser no)
    (PROP_IS_GROUP id_kdomainuser no)
    (PROP_MICROSECONDS id_bdtimedelta num__30)
    (PROP_MICROSECONDS id_bktimedelta num__37)
    (PROP_MICROSECONDS id_brtimedelta num__44)
    (PROP_MICROSECONDS id_bytimedelta num__51)
    (PROP_MICROSECONDS id_ptimedelta num__16)
    (PROP_MICROSECONDS id_wtimedelta num__23)
    (PROP_PASSWORD id_ddomaincredential str__e)
    (PROP_PASSWORD id_hdomaincredential str__i)
    (PROP_PASSWORD id_ldomaincredential str__m)
    (PROP_SECONDS id_bdtimedelta num__31)
    (PROP_SECONDS id_bktimedelta num__38)
    (PROP_SECONDS id_brtimedelta num__45)
    (PROP_SECONDS id_bytimedelta num__52)
    (PROP_SECONDS id_ptimedelta num__17)
    (PROP_SECONDS id_wtimedelta num__24)
    (PROP_SID id_cdomainuser str__f)
    (PROP_SID id_gdomainuser str__j)
    (PROP_SID id_kdomainuser str__n)
    (PROP_TIMEDELTA id_bchost id_bdtimedelta)
    (PROP_TIMEDELTA id_bjhost id_bktimedelta)
    (PROP_TIMEDELTA id_bqhost id_brtimedelta)
    (PROP_TIMEDELTA id_bxhost id_bytimedelta)
    (PROP_TIMEDELTA id_ohost id_ptimedelta)
    (PROP_TIMEDELTA id_vhost id_wtimedelta)
    (PROP_USER id_ddomaincredential id_cdomainuser)
    (PROP_USER id_hdomaincredential id_gdomainuser)
    (PROP_USER id_ldomaincredential id_kdomainuser)
    (PROP_USERNAME id_cdomainuser str__james)
    (PROP_USERNAME id_gdomainuser str__mary)
    (PROP_USERNAME id_kdomainuser str__john)
    (PROP_WINDOWS_DOMAIN id_adomain str__alpha)
    (procnone)
    (= (total-cost) 0)
)
(:goal
(and
    (procnone)
    (prop_host id_curat id_bxhost)
    (prop_host id_ctrat id_bjhost)
    (prop_host id_cwrat id_bchost)
    (prop_host id_cxrat id_ohost)
    (prop_host id_cvrat id_bqhost)
)
)
(:metric minimize (total-cost))
)