Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF292C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCC62133D
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfEXR4s (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 13:56:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:33046 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbfEXR4s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 13:56:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 10:56:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 24 May 2019 10:56:45 -0700
Date:   Fri, 24 May 2019 10:56:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190524175647.GC365@linux.intel.com>
References: <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com>
 <56EA6C7C-F69E-42EB-9CFB-CD0300549298@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56EA6C7C-F69E-42EB-9CFB-CD0300549298@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 10:54:34AM -0700, Andy Lutomirski wrote:
> 
> > On May 24, 2019, at 10:42 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Hmm, I've been thinking more about pulling permissions from the source
> > page.  Conceptually I'm not sure we need to meet the same requirements as
> > non-enclave DSOs while the enclave is being built, i.e. do we really need
> > to force userspace to fully map the enclave in normal memory?
> > 
> > Consider the Graphene scenario where it's building an enclave on the fly.
> > Pulling permissions from the source VMAs means Graphene has to map the
> > code pages of the enclave with X.  This means Graphene will need EXEDMOD
> > (or EXECMEM if Graphene isn't careful).  In a non-SGX scenario this makes
> > perfect sense since there is no way to verify the end result of RW->RX.
> > 
> > But for SGX, assuming enclaves are whitelisted by their sigstruct (checked
> > at EINIT) and because page permissions affect sigstruct.MRENCLAVE, it *is*
> > possible to verify the resulting RX contents.  E.g. for the purposes of
> > LSMs, can't we use the .sigstruct file as a proxy for the enclave and
> > require FILE__EXECUTE on the .sigstruct inode to map/run the enclave?
> 
> I think it’s sound for some but not all use cases. I would imagine that a lot
> of users won’t restrict sigstruct at all — the “use this as a sigstruct”
> permission will be granted to everything and maybe even to memfd. But even
> users like that might want to force their enclaves to be hardened such that
> writable pages are never executable, in which case Graphene may need an
> exception to run.

Heh, I belatedly had the same thought.  See my follow-up about EXECMEM.

> But maybe I’m nuts.
