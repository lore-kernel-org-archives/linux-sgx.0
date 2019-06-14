Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCF8C31E4B
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 17:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD74F2183E
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 17:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfFNRQ7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Jun 2019 13:16:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:6857 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfFNRQ7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Jun 2019 13:16:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:16:57 -0700
X-ExtLoop1: 1
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jun 2019 10:16:55 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.121]) with mapi id 14.03.0415.000;
 Fri, 14 Jun 2019 10:16:56 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>
CC:     "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmAgACMWICAAtC5gIAAgY8AgACfZrA=
Date:   Fri, 14 Jun 2019 17:16:55 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65504665@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
 <20190614004600.GF18385@linux.intel.com>
In-Reply-To: <20190614004600.GF18385@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWE0YzkzNzUtZjZlZS00Y2EzLTg2ZTktOGE4MGExZDU2YzRhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOTkzQ0VCMnlHNU1RcllOWVlwalhGUnU1U2R0UXRPd3E2cnRId2FlMFF0QnNObFdKWU9WS1hSQVk5MXoyZW5tNSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Thursday, June 13, 2019 5:46 PM
> 
> On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> > On 6/11/19 6:02 PM, Sean Christopherson wrote:
> > >On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> > >>I haven't looked at this code closely, but it feels like a lot of
> > >>SGX-specific logic embedded into SELinux that will have to be
> > >>repeated or reused for every security module.  Does SGX not track
> this state itself?
> > >
> > >SGX does track equivalent state.
> > >
> > >There are three proposals on the table (I think):
> > >
> > >   1. Require userspace to explicitly specificy (maximal) enclave
> page
> > >      permissions at build time.  The enclave page permissions are
> provided
> > >      to, and checked by, LSMs at enclave build time.
> > >
> > >      Pros: Low-complexity kernel implementation, straightforward
> auditing
> > >      Cons: Sullies the SGX UAPI to some extent, may increase
> complexity of
> > >            SGX2 enclave loaders.
> > >
> > >   2. Pre-check LSM permissions and dynamically track mappings to
> enclave
> > >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> > >      based on the pre-checked permissions.
> > >
> > >      Pros: Does not impact SGX UAPI, medium kernel complexity
> > >      Cons: Auditing is complex/weird, requires taking enclave-
> specific
> > >            lock during mprotect() to query/update tracking.
> > >
> > >   3. Implement LSM hooks in SGX to allow LSMs to track enclave
> regions
> > >      from cradle to grave, but otherwise defer everything to LSMs.
> > >
> > >      Pros: Does not impact SGX UAPI, maximum flexibility, precise
> auditing
> > >      Cons: Most complex and "heaviest" kernel implementation of the
> three,
> > >            pushes more SGX details into LSMs.
> > >
> > >My RFC series[1] implements #1.  My understanding is that Andy
> > >(Lutomirski) prefers #2.  Cedric's RFC series implements #3.
> > >
> > >Perhaps the easiest way to make forward progress is to rule out the
> > >options we absolutely *don't* want by focusing on the potentially
> > >blocking issue with each option:
> > >
> > >   #1 - SGX UAPI funkiness
> > >
> > >   #2 - Auditing complexity, potential enclave lock contention
> > >
> > >   #3 - Pushing SGX details into LSMs and complexity of kernel
> > > implementation
> > >
> > >
> > >[1]
> > >https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherso
> > >n@intel.com
> >
> > Given the complexity tradeoff, what is the clear motivating example
> > for why
> > #1 isn't the obvious choice? That the enclave loader has no way of
> > knowing a priori whether the enclave will require W->X or WX?  But
> > aren't we better off requiring enclaves to be explicitly marked as
> > needing such so that we can make a more informed decision about
> > whether to load them in the first place?
> 
> Andy and/or Cedric, can you please weigh in with a concrete (and
> practical) use case that will break if we go with #1?  The auditing
> issues for #2/#3 are complex to say the least...

How does enclave loader provide per-page ALLOW_* flags? And a related question is why they are necessary for enclaves but unnecessary for regular executables or shared objects.

What's the story for SGX2 if mmap()'ing non-existing pages is not allowed?

What's the story for auditing?

After everything above has been taken care of properly, will #1 still be simpler than #2/#3?

