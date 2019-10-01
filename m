Return-Path: <SRS0=+C2n=X2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B6AECE587
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 19:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E577215EA
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 19:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfJATK3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Oct 2019 15:10:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:19499 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfJATK3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Oct 2019 15:10:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 12:10:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="205130764"
Received: from yexing-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by fmsmga001.fm.intel.com with ESMTP; 01 Oct 2019 12:10:20 -0700
Date:   Tue, 1 Oct 2019 22:10:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 06/24] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20191001191014.GA12699@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-7-jarkko.sakkinen@linux.intel.com>
 <20190927162735.GC23002@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190927162735.GC23002@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 27, 2019 at 06:27:35PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:37PM +0300, Jarkko Sakkinen wrote:
> > Define the SGX microarchitectural data structures used by various SGX
> > opcodes. This is not an exhaustive representation of all SGX data
> > structures but only those needed by the kernel.
> > 
> > [1] Intel SDM: 37.6 INTEL® SGX DATA STRUCTURES OVERVIEW
> 
> That footnote is not being referred to. Just make it a sentence.

Sure!

> Btw, you could tell your SDM folks to fix formulations like:
> 
> "The use of EAX is implied implicitly by the ENCLS, ENCLU, and ENCLV
> 		   ^^^^^^^^^^^^^^^^^^^
> 
> instructions.... The use of additional registers does not use ModR/M
> encoding and is implied implicitly by the respective leaf function
> 		^^^^^^^^^^^^^^^^^^^
> 
> index."
> 
> "implied" alone wasn't enough I guess. :)

I'd guess have make it a double :-)

/Jarkko
