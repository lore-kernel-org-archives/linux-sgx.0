Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C47C31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 14:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959B520B1F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 14:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437434AbfFLOZ6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:25:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:1584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437408AbfFLOZ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 10:25:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 07:25:57 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2019 07:25:57 -0700
Date:   Wed, 12 Jun 2019 07:25:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
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
Message-ID: <20190612142557.GB20308@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <20190612093221.GA24188@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612093221.GA24188@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 12, 2019 at 04:32:21AM -0500, Dr. Greg wrote:
> With SGX2 we will, by necessity, have to admit the notion that a
> platform owner will not have any effective visibility into code that
> is loaded and executed, since it can come in over a secured network
> connection in an enclave security context.  This advocates for the
> simplest approach possible to providing some type of regulation to any
> form of WX page access.

I believe we're all on the same page in the sense that we all want the
"simplest approach possible", but there's a sliding scale of complexity
between the kernel and userspace.  We can make life simple for userspace
at the cost of additional complexity in the kernel, and vice versa.  The
disagreement is over where to shove the extra complexity.

> Current state of the art, and there doesn't appear to be a reason to
> change this, is to package an enclave in the form of an ELF shared
> library.  It seems straight forward to inherit and act on page
> privileges from the privileges specified on the ELF sections that are
> loaded.  Loaders will have a file descriptor available so an mmap of
> the incoming page with the specified privileges should trigger the
> required LSM interventions and tie them to a specific enclave.
> 
> The current enclave 'standard' also uses layout metadata, stored in a
> special .notes section of the shared image, to direct a loader with
> respect to construction of the enclave stack, heap, TCS and other
> miscellaneous regions not directly coded by the ELF TEXT sections.  It
> seems straight forward to extend this paradigm to declare region(s) of
> an enclave that are eligible to be generated at runtime (EAUG'ed) with
> the RWX protections needed to support dynamically loaded code.
> 
> If an enclave wishes to support this functionality, it would seem
> straight forward to require an enclave to provide a single zero page
> which the loader will mmap with those protections in order to trigger
> the desired LSM checks against that specific enclave.

This is effectively #1, e.g. would require userspace to pre-declare its
intent to make regions W->X.
