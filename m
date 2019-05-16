Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A621C04AAF
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 23:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C5B2070D
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 23:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEPX3u convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 19:29:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:32380 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfEPX3u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 19:29:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 16:29:49 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga006.jf.intel.com with ESMTP; 16 May 2019 16:29:48 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.194]) with mapi id 14.03.0415.000;
 Thu, 16 May 2019 16:29:48 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZtq8EAgAEIegCAABy+AP//k24g
Date:   Thu, 16 May 2019 23:29:47 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E4026@ORSMSX116.amr.corp.intel.com>
References: <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190516051622.GC6388@linux.intel.com>
 <CALCETrVx1hgY67mP+73w5rT+eY+APcfS0YJ+XwtTLNz3CbVNMA@mail.gmail.com>
 <20190516224550.GC11204@linux.intel.com>
In-Reply-To: <20190516224550.GC11204@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjZkOTZkMmYtMTdhOC00MmNiLThjNDItOWM5MDEyMDhiYmUyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM1kyR0FjWVJFcFVLODRSeFVoZVN1aXFWYitybDJRTHpoOHA4ZVpcL0pkUjFRRUFFemZGN05cL0JWZkpCdXlpSnlMIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> > > There is a problem here though. Usually the enclave itself is just a
> > > loader that then loads the application from outside source and
> > > creates the executable pages from the content.
> > >
> > > A great example of this is Graphene that bootstraps unmodified Linux
> > > applications to an enclave:
> > >
> > > https://github.com/oscarlab/graphene
> > >
> >
> > ISTM you should need EXECMEM or similar to run Graphene, then.
> 
> Agreed, Graphene is effectively running arbitrary enclave code.  I'm
> guessing there is nothing that prevents extending/reworking Graphene to
> allow generating the enclave ahead of time so as to avoid populating the
> guts of the enclave at runtime, i.e. it's likely possible to run an
> unmodified application in an enclave without EXECMEM if that's something
> Graphene or its users really care about.

Inefficient use of memory is a problem of running Graphene on SGX1, from at least 2 aspects: 1) heaps/stacks have to be pre-allocated but only a small portion of those pages will be actually used; and 2) dynamic linking is commonly used in *unmodified* applications and all dependent libraries have to be loaded, but only a subset of those pages will actually be used - e.g. most applications use only a small set of functions in libc.so but the whole library still has to be loaded. Hence a practical/efficient solution will require/involve EDMM features available in SGX2. I guess we shall look a bit further into future in order to address this problem properly. And I think it necessary to distinguish enclave virtual ranges from regular ones (probably at VMA level) before we could have a practical solution.
