Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF091C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 21:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8B42075B
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 21:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDVnN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 17:43:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:52309 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDVnN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 17:43:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 14:43:11 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2019 14:43:10 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 4 Jun 2019 14:43:10 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.185]) with mapi id 14.03.0415.000;
 Tue, 4 Jun 2019 14:43:10 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Paul Moore" <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Thread-Topic: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Thread-Index: AQHVGAkjeU1nLGbLQ0COV0gRY1rFBqaMbZsAgAACI4D//5wC8A==
Date:   Tue, 4 Jun 2019 21:43:09 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EDB7D@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
 <CALCETrXf3ujAn6uOwWMU8SRZOvBRb8ALvo_LQvwxc899mrakwQ@mail.gmail.com>
 <20190604203649.GC7775@linux.intel.com>
In-Reply-To: <20190604203649.GC7775@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjk3ZmNiZGEtZTJkNi00ZTMzLWI3MzYtYzNlOTBlZTg5NzlmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiXC9oejQ4MHBleU1KeXlYQXU3S3JFeHhwK1d2WUJGRTJibitsMmRcL2YzQ3N4U0tOY29KSms0SEVSZWtiSmZxUE1PIn0=
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
> Sent: Tuesday, June 04, 2019 1:37 PM
> 
> On Tue, Jun 04, 2019 at 01:29:10PM -0700, Andy Lutomirski wrote:
> > On Fri, May 31, 2019 at 4:32 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long
> > > addr, diff --git a/include/linux/lsm_hooks.h
> > > b/include/linux/lsm_hooks.h index 47f58cfb6a19..0562775424a0 100644
> > > --- a/include/linux/lsm_hooks.h
> > > +++ b/include/linux/lsm_hooks.h
> > > @@ -1446,6 +1446,14 @@
> > >   * @bpf_prog_free_security:
> > >   *     Clean up the security information stored inside bpf prog.
> > >   *
> > > + * Security hooks for Intel SGX enclaves.
> > > + *
> > > + * @enclave_load:
> > > + *     On success, returns 0 and optionally adjusts @allowed_prot
> > > + *     @vma: the source memory region of the enclave page being
> loaded.
> > > + *     @prot: the initial protection of the enclave page.
> >
> > What do you mean "initial"?  The page is always mapped PROT_NONE when
> > this is called, right?  I feel like I must be missing something here.
> 
> Initial protection in the EPCM.  Yet another reason to ignore SECINFO.

I know you guys are talking in the background that all pages are mmap()'ed PROT_NONE. But that's an unnecessary limitation. And @prot here should be @target_vma->vm_flags&(VM_READ|VM_WRITE|VM_EXEC). 
