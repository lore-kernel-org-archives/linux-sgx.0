Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E58BC31E45
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65EFE20850
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfFNAqC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 20:46:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:18675 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfFNAqC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 20:46:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 17:46:01 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2019 17:46:00 -0700
Date:   Thu, 13 Jun 2019 17:46:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190614004600.GF18385@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> On 6/11/19 6:02 PM, Sean Christopherson wrote:
> >On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> >>I haven't looked at this code closely, but it feels like a lot of
> >>SGX-specific logic embedded into SELinux that will have to be repeated or
> >>reused for every security module.  Does SGX not track this state itself?
> >
> >SGX does track equivalent state.
> >
> >There are three proposals on the table (I think):
> >
> >   1. Require userspace to explicitly specificy (maximal) enclave page
> >      permissions at build time.  The enclave page permissions are provided
> >      to, and checked by, LSMs at enclave build time.
> >
> >      Pros: Low-complexity kernel implementation, straightforward auditing
> >      Cons: Sullies the SGX UAPI to some extent, may increase complexity of
> >            SGX2 enclave loaders.
> >
> >   2. Pre-check LSM permissions and dynamically track mappings to enclave
> >      pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
> >      based on the pre-checked permissions.
> >
> >      Pros: Does not impact SGX UAPI, medium kernel complexity
> >      Cons: Auditing is complex/weird, requires taking enclave-specific
> >            lock during mprotect() to query/update tracking.
> >
> >   3. Implement LSM hooks in SGX to allow LSMs to track enclave regions
> >      from cradle to grave, but otherwise defer everything to LSMs.
> >
> >      Pros: Does not impact SGX UAPI, maximum flexibility, precise auditing
> >      Cons: Most complex and "heaviest" kernel implementation of the three,
> >            pushes more SGX details into LSMs.
> >
> >My RFC series[1] implements #1.  My understanding is that Andy (Lutomirski)
> >prefers #2.  Cedric's RFC series implements #3.
> >
> >Perhaps the easiest way to make forward progress is to rule out the
> >options we absolutely *don't* want by focusing on the potentially blocking
> >issue with each option:
> >
> >   #1 - SGX UAPI funkiness
> >
> >   #2 - Auditing complexity, potential enclave lock contention
> >
> >   #3 - Pushing SGX details into LSMs and complexity of kernel implementation
> >
> >
> >[1] https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com
> 
> Given the complexity tradeoff, what is the clear motivating example for why
> #1 isn't the obvious choice? That the enclave loader has no way of knowing a
> priori whether the enclave will require W->X or WX?  But aren't we better
> off requiring enclaves to be explicitly marked as needing such so that we
> can make a more informed decision about whether to load them in the first
> place?

Andy and/or Cedric, can you please weigh in with a concrete (and practical)
use case that will break if we go with #1?  The auditing issues for #2/#3
are complex to say the least...
