Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E431C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 23:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723BD2087C
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 23:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfCZXUU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 19:20:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:5842 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfCZXUU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 19:20:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 16:20:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="158669207"
Received: from kmsmsx152.gar.corp.intel.com ([172.21.73.87])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2019 16:20:16 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 KMSMSX152.gar.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0415.000;
 Wed, 27 Mar 2019 07:20:01 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Topic: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Index: AQHU3zky6JmIjy9D9kKUr6BC7GDLPqYdVzoAgAAkQICAAPek0P//hiCAgACc10A=
Date:   Tue, 26 Mar 2019 23:19:59 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989356F3436@PGSMSX112.gar.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
 <1553602654.17255.15.camel@intel.com>
 <20190326142719.GC3757@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989356F307D@PGSMSX112.gar.corp.intel.com>
 <20190326215727.GG3757@linux.intel.com>
In-Reply-To: <20190326215727.GG3757@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGM1YjM3NzEtZTI1MS00NzJlLWFjMmYtY2MxZDkwYzAxNzU2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRVdVczFaTU9MZE9mZENWY2EwXC9HMTVhYlVJWEMzWExSTURcLzU4emFJT2h5dVc5NlBPOG82c3FRK2htMEtITmJiIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Tue, Mar 26, 2019 at 02:25:52PM -0700, Huang, Kai wrote:
> > >
> > > That being said, this in no way impacts KVM's ability to virtualize SGX, e.g.
> > > KVM can directly do CPUID and {RD,WR}MSR to probe the capabilities
> > > of the platform as needed.
> >
> > I am not following. KVM can do whatever it wants, but it cannot change
> > the fact that KVM guest cannot run intel enclave if platform's MSRs
> > are configured to 3rd party and locked.
> >
> > Or am I misunderstanding?
> 
> What does that have to do with this patch?  The only thing this patch does is
> clear a *software* bit that says "SGX LC is enabled" so that the kernel can
> make the reasonable assumption that the MSRs are writable when
> X86_FEATURE_SGX_LC=1.

Sorted out offline discussion with you. Will let you handle :)

Thanks,
-Kai
