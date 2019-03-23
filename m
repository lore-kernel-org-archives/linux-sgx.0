Return-Path: <SRS0=lC4h=R2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B0EC43381
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Mar 2019 17:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A84921841
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Mar 2019 17:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfCWRgg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Mar 2019 13:36:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:7532 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfCWRgf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 23 Mar 2019 13:36:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Mar 2019 10:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="143234049"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2019 10:36:34 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sat, 23 Mar 2019 10:36:34 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.65]) with mapi id 14.03.0415.000;
 Sat, 23 Mar 2019 10:36:33 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUIADt/WAgADIIJA=
Date:   Sat, 23 Mar 2019 17:36:33 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com>
In-Reply-To: <20190322215903.GE12666@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDIzMWQ1ODItNjU4MS00ZDk2LTlhMmYtYTY5ZmMyOGI0OTE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiY0xcLzRkdEhvbENjTGVvY2pmN1dNUzBYUWRtV0d2bUFQMVRNVVJrXC9RZGErQ0JkZ2RoZ2tYcGJlaWU1M2NnRzJFIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Sean,

> Although its just 9 LOC, consider its impact on someone who is looking
> at
> the kernel's SGX support for the first time.  Questions they may have
> when
> looking at the vDSO code/documentation:
> 
>   - What's an exit handler?
>   - Why is an exit handler optional?  Don't I always want to handle
> exits?
>   - What value should my exit handler return?
>   - What should my exit handler do if it detects an error?
>   - Why would I want to preserve %rbp and not %rsp?
>   - Isn't it insecure to use the untrusted stack in my enclave?
> 
> AFAIK, the only reason to preserve %rbp instead of %rsp, i.e. support an
> "exit handler" callback, is to be able to implement an o-call scheme
> using
> the untrusted stack to pass data.  Every idea I came up with for using
> the
> callback, e.g. logging, handling stack corruptiong, testing hooks,
> etc...
> was at worst no more difficult to implement when using a barebones vDSO.
> 
> So, given the choice between a) documenting and maintaining all the
> baggage
> that comes with the exit handler and b) saying "go use signals", I chose
> option b.

Disagreed!

This API is NOT even x86_64 compatible and NOT intended to be used by average developers. Instead, this API will be used by SGX SDK vendors who have all the needed background/expertise. And flexibility is way more important to them than reduced documentation. Just imagine how much one needs to read to understand how SGX works, do you really think a function comprised of 20 or so LOC will be a big deal? 

Anyway, the documentation needed IMO will not exceed even 1 page, which will be way shorter than most of docs in kernel source tree. I'll be more than happy to help you out if that's out of your competence!

Regarding maintenance, I see an API may require maintenance for 2 possible categories of reasons: 1) its interface cannot satisfy emerging applications; or 2) the infrastructure it relies on has changed. Generally speaking, a more generic API with less assumption/dependence on other components will impose lower maintenance cost in the long run. Comparing our proposals, they share the same dependences (i.e. SGX ISA and vDSO extable) but mine is more generic (as yours could be implemented using mine as a subroutine). Thus, I bet your proposal will impose higher maintenance cost in the long run.

-Cedric
