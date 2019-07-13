Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC07C742A7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 15:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A865D20838
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 15:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfGMPKc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 11:10:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:15017 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbfGMPKc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 11:10:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 08:10:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,486,1557212400"; 
   d="scan'208";a="318271489"
Received: from hbriegel-mobl.ger.corp.intel.com ([10.252.50.48])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2019 08:10:26 -0700
Message-ID: <c6a99c107c1e6b814c1968146c87291c3e84aa2f.camel@linux.intel.com>
Subject: Re: [RFC PATCH v4 1/3] selftests/x86/sgx: Fix Makefile for SGX
 selftest
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Cedric Xing <cedric.xing@intel.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
Date:   Sat, 13 Jul 2019 18:10:25 +0300
In-Reply-To: <757d44a0e67bfa09d97eea918bc0d20383b5e80e.1563000446.git.cedric.xing@intel.com>
References: <cover.1563000446.git.cedric.xing@intel.com>
         <757d44a0e67bfa09d97eea918bc0d20383b5e80e.1563000446.git.cedric.xing@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2019-07-12 at 23:51 -0700, Cedric Xing wrote:
> The original x86/sgx/Makefile didn't work when "x86/sgx" was specified as the
> test target, nor did it work with "run_tests" as the make target. Yet another
> problem was that it breaks 32-bit only build. This patch fixes those problems,
> along with adjustments to compiler/linker options and simplifications to the
> build rules.
> 
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>

You must split this in quite a few separate patches:

1. One for each fix.
2. At least one patch for each change in compiler and linker options with a
   commit message clearly expalaining why the change was made.
3. One for each simplification.

We don't support 32-bit build:

config INTEL_SGX
	bool "Intel SGX core functionality"
	depends on X86_64 && CPU_SUP_INTEL
	
/Jarkko

