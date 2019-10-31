Return-Path: <SRS0=vy4m=YY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6035CA9ECB
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Oct 2019 21:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3F9E216F4
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Oct 2019 21:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfJaVR6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:17:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:43734 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJaVR5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 31 Oct 2019 17:17:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 14:17:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="402024076"
Received: from epobrien-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.10.103])
  by fmsmga006.fm.intel.com with ESMTP; 31 Oct 2019 14:17:46 -0700
Date:   Thu, 31 Oct 2019 23:17:44 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191031211721.GD10507@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 30, 2019 at 09:45:05AM -0400, Stephen Smalley wrote:
> On 10/28/19 5:03 PM, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the SGX hosted software entity is disallowed to
> > access the memory inside the enclave enforced by the CPU. We call these
> > entities as enclaves.
> > 
> > This commit implements a driver that provides an ioctl API to construct
> > and run enclaves. Enclaves are constructed from pages residing in
> > reserved physical memory areas. The contents of these pages can only be
> > accessed when they are mapped as part of an enclave, by a hardware
> > thread running inside the enclave.
> > 
> > The starting state of an enclave consists of a fixed measured set of
> > pages that are copied to the EPC during the construction process by
> > using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> > that defines the enclave properties.
> > 
> > Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
> > EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> > the EPC and EINIT check a given signed measurement and moves the enclave
> > into a state ready for execution.
> > 
> > An initialized enclave can only be accessed through special Thread Control
> > Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> > function converts a thread into enclave mode and continues the execution in
> > the offset defined by the TCS provided to EENTER. An enclave is exited
> > through syscall, exception, interrupts or by explicitly calling another
> > ENCLU leaf EEXIT.
> > 
> > The permissions, which enclave page is added will set the limit for maximum
> > permissions that can be set for mmap() and mprotect(). This will
> > effectively allow to build different security schemes between producers and
> > consumers of enclaves. Later on we can increase granularity with LSM hooks
> > for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> > consumers)
> 
> Where do things stand wrt to ensuring that SGX cannot be used to introduce
> executable mappings that were never authorized by the LSM (or never measured
> by IMA)?

This was the latest discussion about that subject:

https://lore.kernel.org/linux-sgx/CALCETrWDLX68Vi4=9Dicq9ATmJ5mv36bzrc02heNYaHaBeWumQ@mail.gmail.com/

/Jarkko
