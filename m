Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9980AC48BE3
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 21:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 791B72070B
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 21:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFUVWP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jun 2019 17:22:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:60280 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUVWO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jun 2019 17:22:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 14:22:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="244106919"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga001.jf.intel.com with ESMTP; 21 Jun 2019 14:22:14 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 14:22:13 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.252]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 14:22:13 -0700
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
Subject: RE: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Topic: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEA
Date:   Fri, 21 Jun 2019 21:22:13 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-11-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjQ5MzIyYWYtNTYzYS00NDZjLWI1NGUtN2I5ZmFlYzEwMWUzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTTRvRVF6TkIwOWc4dEhRdG9ZRTR1M3ZlQkU1RFhGemJIRDRlcEVcL2x2WVlxVFlCSFdzZUlaR0ppdXhqVHJGT3IifQ==
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
> Intended use of each permission:
> 
>   - SGX_EXECDIRTY: dynamically load code within the enclave itself
>   - SGX_EXECUNMR: load unmeasured code into the enclave, e.g. Graphene

Why does it matter whether a code page is measured or not?

>   - SGX_EXECANON: load code from anonymous memory (likely Graphene)

Graphene doesn't load code from anonymous memory. It loads code dynamically though, as in SGX_EXECDIRTY case.

>   - SGX_EXECUTE: load an enclave from a file, i.e. normal behavior

Why is SGX_EXECUTE needed from security perspective? Or why isn't FILE__EXECUTE sufficient?
