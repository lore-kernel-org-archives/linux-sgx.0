Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196E0C43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51AF2070B
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFURJk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jun 2019 13:09:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:39921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFURJj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jun 2019 13:09:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 10:09:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="162720186"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jun 2019 10:09:40 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 10:09:40 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.46]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 10:09:40 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>
Subject: RE: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to map
 enclave page WX
Thread-Topic: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to
 map enclave page WX
Thread-Index: AQHVJu2+pgr/3JM48UeUDAsxgoYlgKamWU8w
Date:   Fri, 21 Jun 2019 17:09:39 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F655184C3@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-9-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-9-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODM5OTc3MWEtZWE3My00ZGQwLWFhNDAtZGE0MzhiOWIyYzA0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWUF2QWl2ZWdtNWI4SSs3aTcwODNcL3dBK3lcL0ZGSm1GSWpiUk5KTFNpcnFmQjArejIyWE5cLzNDSGJBSDBXRFlRUiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Wednesday, June 19, 2019 3:24 PM
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702cf46ca..fc239e541b62 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6726,6 +6726,23 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>  }
>  #endif
> 
> +#ifdef CONFIG_INTEL_SGX
> +static int selinux_enclave_map(unsigned long prot)
> +{
> +	const struct cred *cred = current_cred();
> +	u32 sid = cred_sid(cred);
> +
> +	/* SGX is supported only in 64-bit kernels. */
> +	WARN_ON_ONCE(!default_noexec);
> +
> +	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> +		return avc_has_perm(&selinux_state, sid, sid,
> +				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
> +				    NULL);

Why isn't SGX_MAPWX enclave specific but process wide?
