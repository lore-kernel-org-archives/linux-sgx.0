Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E95CC31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 14:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D6D208CA
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 14:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfFLOeJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:34:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:6916 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbfFLOeI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 10:34:08 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 07:34:07 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jun 2019 07:34:05 -0700
Date:   Wed, 12 Jun 2019 07:34:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>, q@linux.intel.com
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Message-ID: <20190612143405.GC20308@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
 <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F655010EF@ORSMSX116.amr.corp.intel.com>
 <331B31BF-9892-4FB3-9265-3E37412F80F4@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <331B31BF-9892-4FB3-9265-3E37412F80F4@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 11, 2019 at 05:09:28PM -0700, Andy Lutomirski wrote:
> 
> On Jun 10, 2019, at 3:28 PM, Xing, Cedric <cedric.xing@intel.com> wrote:
> 
> >> From: Andy Lutomirski [mailto:luto@kernel.org]
> >> Sent: Monday, June 10, 2019 12:15 PM
> >> This seems like an odd workflow.  Shouldn't the #PF return back to
> >> untrusted userspace so that the untrusted user code can make its own
> >> decision as to whether it wants to EAUG a page there as opposed to, say,
> >> killing the enclave or waiting to keep resource usage under control?
> > 
> > This may seem odd to some at the first glance. But if you can think of how
> > static heap (pre-allocated by EADD before EINIT) works, the load parses the
> > "metadata" coming with the enclave to decide the address/size of the heap,
> > EADDs it, and calls it done. In the case of "dynamic" heap (allocated
> > dynamically by EAUG after EINIT), the same thing applies - the loader
> > determines the range of the heap, tells the SGX module about it, and calls
> > it done. Everything else is the between the enclave and the SGX module.
> > 
> > In practice, untrusted code usually doesn't know much about enclaves, just
> > like it doesn't know much about the shared objects loaded into its address
> > space either. Without the necessary knowledge, untrusted code usually just
> > does what it is told (via o-calls, or return value from e-calls), without
> > judging that's right or wrong. 
> > 
> > When it comes to #PF like what I described, of course a signal could be
> > sent to the untrusted code but what would it do then? Usually it'd just
> > come back asking for a page at the fault address. So we figured it'd be
> > more efficient to just have the kernel EAUG at #PF. 
> > 
> > Please don't get me wrong though, as I'm not dictating what the s/w flow
> > shall be. It's just going to be a choice offered to user mode. And that
> > choice was planned to be offered via mprotect() - i.e. a writable vma
> > causes kernel to EAUG while a non-writable vma will result in a signal
> > (then the user mode could decide whether to EAUG). The key point is
> > flexibility - as we want to allow all reasonable s/w flows instead of
> > dictating one over others. We had similar discussions on vDSO API before.
> > And I think you accepted my approach because of its flexibility. Am I
> > right?
> 
> As long as user code can turn this off, I have no real objection. But it
> might make sense to have it be more explicit — have an ioctl set up a range
> as “EAUG-on-demand”.

This was part of the motivation behind changing SGX_IOC_ENCLAVE_ADD_PAGE
to SGX_IOC_ENCLAVE_ADD_REGION and adding a @flags parameter.  E.g. adding
support for "EAUG-on-demand" regions would just be a new flag.

> But this is all currently irrelevant. We can argue about it when the patches
> show up. :)
