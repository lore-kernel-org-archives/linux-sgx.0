Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E77C31E4B
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 17:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B0B217D6
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 17:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfFNRp6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Jun 2019 13:45:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:53669 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfFNRp5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Jun 2019 13:45:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:45:56 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2019 10:45:56 -0700
Date:   Fri, 14 Jun 2019 10:45:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-security-module@vger.kernel.org" 
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
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190614174556.GJ12191@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
 <20190614004600.GF18385@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65504665@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65504665@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 14, 2019 at 10:16:55AM -0700, Xing, Cedric wrote:
> > From: Christopherson, Sean J
> > Sent: Thursday, June 13, 2019 5:46 PM
> > 
> > On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> > > On 6/11/19 6:02 PM, Sean Christopherson wrote:
> > > >My RFC series[1] implements #1.  My understanding is that Andy
> > > >(Lutomirski) prefers #2.  Cedric's RFC series implements #3.
> > > >
> > > >Perhaps the easiest way to make forward progress is to rule out the
> > > >options we absolutely *don't* want by focusing on the potentially
> > > >blocking issue with each option:
> > > >
> > > >   #1 - SGX UAPI funkiness
> > > >
> > > >   #2 - Auditing complexity, potential enclave lock contention
> > > >
> > > >   #3 - Pushing SGX details into LSMs and complexity of kernel
> > > > implementation
> > > >
> > > >
> > > >[1]
> > > >https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherso
> > > >n@intel.com
> > >
> > > Given the complexity tradeoff, what is the clear motivating example
> > > for why
> > > #1 isn't the obvious choice? That the enclave loader has no way of
> > > knowing a priori whether the enclave will require W->X or WX?  But
> > > aren't we better off requiring enclaves to be explicitly marked as
> > > needing such so that we can make a more informed decision about
> > > whether to load them in the first place?
> > 
> > Andy and/or Cedric, can you please weigh in with a concrete (and
> > practical) use case that will break if we go with #1?  The auditing
> > issues for #2/#3 are complex to say the least...
> 
> How does enclave loader provide per-page ALLOW_* flags?

Unchanged from my RFC, i.e. specified at SGX_IOC_ENCLAVE_ADD_PAGE(S).

> And a related question is why they are necessary for enclaves but
> unnecessary for regular executables or shared objects.

Because at mmap()/mprotect() time we don't have the source file of the
enclave page to check SELinux's FILE__EXECUTE or AppArmor's AA_EXEC_MMAP.

> What's the story for SGX2 if mmap()'ing non-existing pages is not allowed?

Userspace will need to invoke an ioctl() to tell SGX "this range can be
EAUG'd".

> 
> What's the story for auditing?

It happens naturally when security_enclave_load() is called.  Am I
missing something?

> After everything above has been taken care of properly, will #1 still be
> simpler than #2/#3?

The state tracking of #2/#3 doesn't scare me, it's purely the auditing.
Holding an audit message for an indeterminate amount of time is a
nightmare.

Here's a thought.  What if we simply require FILE__EXECUTE or AA_EXEC_MAP
to load any enclave page from a file?  Alternatively, we could add an SGX
specific file policity, e.g. FILE__ENCLAVELOAD and AA_MAY_LOAD_ENCLAVE.
As in my other email, SELinux's W^X restrictions can be tied to the process,
i.e. they can be checked at mmap()/mprotect() without throwing a wrench in
auditing.
