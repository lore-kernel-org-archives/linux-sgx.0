Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C5FC43218
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 22:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D28E2082E
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 22:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfFJWGz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 18:06:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:63267 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfFJWGz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 18:06:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 15:06:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,576,1557212400"; 
   d="scan'208";a="183581355"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jun 2019 15:06:54 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 10 Jun 2019 15:06:53 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.133]) with mapi id 14.03.0415.000;
 Mon, 10 Jun 2019 15:06:53 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v2 1/5] mm: Introduce vm_ops->may_mprotect()
Thread-Topic: [RFC PATCH v2 1/5] mm: Introduce vm_ops->may_mprotect()
Thread-Index: AQHVHA01/2g2StwB+UmAXBpwpA92D6aVeUUAgAAN64D//6b7AIAAmlyA//+sFAA=
Date:   Mon, 10 Jun 2019 22:06:52 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6550108B@ORSMSX116.amr.corp.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-2-sean.j.christopherson@intel.com>
 <20190610150600.GA3752@linux.intel.com>
 <20190610155549.GB15995@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654FFD59@ORSMSX116.amr.corp.intel.com>
 <20190610194941.GK15995@linux.intel.com>
In-Reply-To: <20190610194941.GK15995@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTYxMzYxYzYtOTRmNS00MDVjLWJhNjctMGEyYzIwOWFhOGY1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNCs5VXBmdFpzS2tRQllOMUlwNnd5cFJRNlwvXC9tVGUxM3lYazlBTkpQYlowUHNvNTVwWExGaXZGc1lCUVorSHNmIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Monday, June 10, 2019 12:50 PM
> 
> On Mon, Jun 10, 2019 at 10:47:52AM -0700, Xing, Cedric wrote:
> > > From: Christopherson, Sean J
> > > Sent: Monday, June 10, 2019 8:56 AM
> > >
> > > > > As a result, LSM policies cannot be meaningfully applied, e.g.
> > > > > an LSM can deny access to the EPC as a whole, but can't deny
> > > > > PROT_EXEC on page that originated in a non-EXECUTE file (which
> > > > > is long gone by the time
> > > > > mprotect() is called).
> > > >
> > > > I have hard time following what is paragraph is trying to say.
> > > >
> > > > > By hooking mprotect(), SGX can make explicit LSM upcalls while
> > > > > an enclave is being built, i.e. when the kernel has a handle to
> > > > > origin of each enclave page, and enforce the result of the LSM
> > > > > policy whenever userspace maps the enclave page in the future.
> > > >
> > > > "LSM policy whenever calls mprotect()"? I'm no sure why you mean
> > > > by mapping here and if there is any need to talk about future.
> > > > Isn't this needed now?
> > >
> > > Future is referring to the timeline of a running kernel, not the
> > > future of the kernel code.
> > >
> > > Rather than trying to explain all of the above with words, I'll
> > > provide code examples to show how ->may_protect() will be used by
> > > SGX and why it is the preferred solution.
> >
> > The LSM concept is to separate security policy enforcement from the
> > rest of the kernel. For modules, the "official" way is to use VM_MAY*
> > flags to limit allowable permissions, while LSM uses
> security_file_mprotect().
> > I guess that's why we didn't have .may_mprotect() in the first place.
> 
> Heh, so I've typed up about five different responses to this comment.
> In doing so, I think I've convinced myself that ->may_mprotect() is
> unnecessary.  Rther than hook mprotect(), simply update the VM_MAY*
> flags during mmap(), with all bits cleared if there isn't an associated
> enclave page.  IIRC, the need to add ->may_protect() came about when we
> were exploring more dynamic interplay between SGX and LSMs.
> 
> > What you are doing is enforcing some security policy outside of LSM,
> > which is dirty from architecture perspective.
> 
> No, the enclave page protections are enforced regardless of LSM policy,
> and in v2 those protections are immutable.  Yes, the explicit enclave
> page protection bits are being added primarily for LSMs, but they don't
> impact functionality other than at the security_enclave_load()
> touchpoint.

Disagreed.

You can say you want to enforce "something" without LSM. But what's the purpose of that "something" without LSM? Why doesn't the original mprotect() enforce that "something"?

It *does* affect functionality because user mode code has to figure out an "explicit protection" to make sure the enclave would work with *and also* without LSM. That said, the "explicit protection" can neither be too restrictive (or enclave wouldn't work) nor be too permissive (or LSM policies are violated). But what if the user mode code doesn't have appropriate "explicit protection" ahead of time as it is just going to mprotect() as the enclave requests at runtime?

And your restrictions on mmap()'ing non-existing pages also have great impacts to SGX2 support.

I think some reasonable answers are needed to the above questions before we can call this proposal viable. 
