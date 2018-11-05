Return-Path: <SRS0=4Rt9=NQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB223C46475
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7332A2085A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7332A2085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbeKEXzz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:55:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:55645 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbeKEXzz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Nov 2018 18:55:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2018 06:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,468,1534834800"; 
   d="scan'208";a="101634418"
Received: from fhoeg-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.66])
  by fmsmga002.fm.intel.com with ESMTP; 05 Nov 2018 06:35:48 -0800
Date:   Mon, 5 Nov 2018 16:35:46 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 11/23] x86/sgx: Add definitions for SGX's CPUID leaf
 and variable sub-leafs
Message-ID: <20181105143415.GA2798@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-12-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcgFstv5EjY2DzsLGAimxf3Z2g-Mych1zW40txS9b7Bmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcgFstv5EjY2DzsLGAimxf3Z2g-Mych1zW40txS9b7Bmg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181105143546.6JIrBsXMnvZ14ghJLTdgPqfsp8vzgIwL6I8hXpzNcFQ@z>

On Sat, Nov 03, 2018 at 03:11:39PM +0200, Andy Shevchenko wrote:
> On Sat, Nov 3, 2018 at 1:16 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > SGX defines its own CPUID leaf, 0x12, along with a variable number of
> > sub-leafs.  Sub-leafs 0 and 1 are always available if SGX is supported
> > and enumerate various SGX features, e.g. instruction sets and enclave
> > capabilities.  Sub-leafs 2+ are variable, both in their existence and
> > in what they enumerate.  Bits 3:0 of EAX report the sub-leaf type,
> > with the remaining bits in EAX, EBX, ECX and EDX being type-specific.
> > Currently, the only known sub-leaf type enumerates an EPC section.  An
> > EPC section is simply a range of EPC memory available to software.
> > The "list" of varaible SGX sub-leafs is NULL-terminated, i.e. software
> > is expected to query CPUID until an invalid sub-leaf is encountered.
> 
> > +       SGX_CPUID_SUB_LEAF_TYPE_MASK    = 0xF,
> 
> GENMASK() if it suits here?
> 
> P.S. Btw, BIT() and GENMASK() macros are now in a separate header,
> i.e. linux/bits.h, perhaps you might need to revisit code to include
> it explicitly

Agreed. I would also think that is should be renamed simply as
SGX_CPUID_SUBLEAF_MASK.

/Jarkko
