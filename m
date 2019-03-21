Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9FBC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 21:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D742621917
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 21:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfCUVlm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 17:41:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:27756 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfCUVlm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 17:41:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 14:41:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,254,1549958400"; 
   d="scan'208";a="330805368"
Received: from pgsmsx106.gar.corp.intel.com ([10.221.44.98])
  by fmsmga005.fm.intel.com with ESMTP; 21 Mar 2019 14:41:38 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 PGSMSX106.gar.corp.intel.com ([169.254.9.12]) with mapi id 14.03.0415.000;
 Fri, 22 Mar 2019 05:41:37 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH v19 17/27] x86/sgx: Add provisioning
Thread-Topic: [PATCH v19 17/27] x86/sgx: Add provisioning
Thread-Index: AQHU3QbvP5BGVbOPA0+DLUjy9mJ6e6YS3xIAgAH2tgCAAM/HAIAA/cbg
Date:   Thu, 21 Mar 2019 21:41:37 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989356E6613@PGSMSX112.gar.corp.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <20190319200912.GH25575@linux.intel.com> <1553134108.1952.4.camel@intel.com>
 <20190321143208.GL4603@linux.intel.com>
In-Reply-To: <20190321143208.GL4603@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2JiMTg0MzUtNGY5NS00NzY2LTg1ZmItNTk4NzI1YTJjOTU2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMExiWjJGc1cxTlZ2cHIwY0haRGQxbkZvSnpSQXhYeVFURlNOWUo1SnJHeEJPNGkzWFNISGdmM0hTVlp3Ym82RiJ9
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

> On Thu, Mar 21, 2019 at 02:08:36AM +0000, Huang, Kai wrote:
> > On Tue, 2019-03-19 at 13:09 -0700, Sean Christopherson wrote:
> > > On Sun, Mar 17, 2019 at 11:14:46PM +0200, Jarkko Sakkinen wrote:
> > > > In order to provide a mechanism for devilering provisoning rights:
> > > >
> > > > 1. Add a new file to the securityfs file called sgx/provision that works
> > > >    as a token for allowing an enclave to have the provisioning privileges.
> > > > 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that
> accepts the
> > > >    following data structure:
> > > >
> > > >    struct sgx_enclave_set_attribute {
> > > >            __u64 addr;
> > > >            __u64 token_fd;
> > > >    };
> >
> > Would you elaborate why the name is "token_fd"? I think *token* in SGX
> > has more specific meaning?
> 
> I'm open for other names.

How about attribute_fd, which is consistent with your IOCTL?

Thanks,
-Kai
