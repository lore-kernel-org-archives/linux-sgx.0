Return-Path: <SRS0=237/=X3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E499EC4360C
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Oct 2019 23:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6EA9222C0
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Oct 2019 23:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfJBXSQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Oct 2019 19:18:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:28074 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfJBXSQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Oct 2019 19:18:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="196158281"
Received: from tanabarr-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.95.47])
  by orsmga006.jf.intel.com with ESMTP; 02 Oct 2019 16:18:05 -0700
Date:   Thu, 3 Oct 2019 02:18:04 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v22 16/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20191002231804.GA14315@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:47PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The basic concept and implementation is very similar to the kernel's
> exception fixup mechanism.  The key differences are that the kernel
> handler is hardcoded and the fixup entry addresses are relative to
> the overall table as opposed to individual entries.

The commit message is missing description of what the commit does.
Please explain "what" before "why". Now "what" is completely lacking.
This paragraph starts as if there was an invisible paragraph before it.

You should start by explaining briefly about this:

1. A brief description of what vdso2c is.
2. A brief description of what changes you do to vdso2.
3. A brief description of what kernel change you do.
4. A brief description of the flow how the expection gets delivered
   to the user space.

All of this is completely missing.

> Hardcoding the kernel handler avoids the need to figure out how to
> get userspace code to point at a kernel function.  Given that the
> expected usage is to propagate information to userspace, dumping all
> fault information into registers is likely the desired behavior for
> the vast majority of yet-to-be-created functions.  Use registers
> DI, SI and DX to communicate fault information, which follows Linux's
> ABI for register consumption and hopefully avoids conflict with
> hardware features that might leverage the fixup capabilities, e.g.
> register usage for SGX instructions was at least partially designed
> with calling conventions in mind.

No description of what is stored in DI, SI and DX. Also there is two
space bars after *every* sentence. Your text editor is totally broken
somehow. Also DB/BP exception is not described.

> Making fixup addresses relative to the overall table allows the table
> to be stripped from the final vDSO image (it's a kernel construct)
> without complicating the offset logic, e.g. entry-relative addressing
> would also need to account for the table's location relative to the
> image.
> 
> Regarding stripping the table, modify vdso2c to extract the table from
> the raw, a.k.a. unstripped, data and dump it as a standalone byte array
> in the resulting .c file.  The original base of the table, its length
> and a pointer to the byte array are captured in struct vdso_image.
> Alternatively, the table could be dumped directly into the struct,
> but because the number of entries can vary per image, that would
> require either hardcoding a max sized table into the struct definition
> or defining the table as a flexible length array.  The flexible length
> array approach has zero benefits, e.g. the base/size are still needed,
> and prevents reusing the extraction code, while hardcoding the max size
> adds ongoing maintenance just to avoid exporting the explicit size.
> 
> The immediate use case is for Intel Software Guard Extensions (SGX).
> SGX introduces a new CPL3-only "enclave" mode that runs as a sort of
> black box shared object that is hosted by an untrusted "normal" CPl3
> process.
> 
> Entering an enclave can only be done through SGX-specific instructions,
> EENTER and ERESUME, and is a non-trivial process.  Because of the
> complexity of transitioning to/from an enclave, the vast majority of
> enclaves are expected to utilize a library to handle the actual
> transitions.  This is roughly analogous to how e.g. libc implementations
> are used by most applications.
> 
> Another crucial characteristic of SGX enclaves is that they can generate
> exceptions as part of their normal (at least as "normal" as SGX can be)
> operation that need to be handled *in* the enclave and/or are unique
> to SGX.
> 
> And because they are essentially fancy shared objects, a process can
> host any number of enclaves, each of which can execute multiple threads
> simultaneously.
> 
> Putting everything together, userspace enclaves will utilize a library
> that must be prepared to handle any and (almost) all exceptions any time
> at least one thread may be executing in an enclave.  Leveraging signals
> to handle the enclave exceptions is unpleasant, to put it mildly, e.g.
> the SGX library must constantly (un)register its signal handler based
> on whether or not at least one thread is executing in an enclave, and
> filter and forward exceptions that aren't related to its enclaves.  This
> becomes particularly nasty when using multiple levels of libraries that
> register signal handlers, e.g. running an enclave via cgo inside of the
> Go runtime.
> 
> Enabling exception fixup in vDSO allows the kernel to provide a vDSO
> function that wraps the low-level transitions to/from the enclave, i.e.
> the EENTER and ERESUME instructions.  The vDSO function can intercept
> exceptions that would otherwise generate a signal and return the fault
> information directly to its caller, thus avoiding the need to juggle
> signal handlers.
> 
> Note that unlike the kernel's _ASM_EXTABLE_HANDLE implementation, the
> 'C' version of _ASM_VDSO_EXTABLE_HANDLE doesn't use a pre-compiled
> assembly macro.  Duplicating four lines of code is simpler than adding
> the necessary infrastructure to generate pre-compiled assembly and the
> intended benefit of massaging GCC's inlining algorithm is unlikely to
> realized in the vDSO any time soon, if ever.

Rest of the story is a mess with bits of pieces of "what" and "why"
and mixed together. You could probably make the whole like 50% smaller
with a better organization.

I never understood anything of this commit message. Only by looking
at the code change and completely ignoring the commit message I could
understand what the heck is going on. The commit message in the current
for makes me understand *less* the code change.

It would be even better to delete it completely than have it in the
current form. I would suggest that you do that and concentrate writing
steps 1-4 that I described above.

/Jarkko
