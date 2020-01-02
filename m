Return-Path: <SRS0=JJHd=2X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB23C2D0DC
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 16:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C68E206E6
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 16:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgABQtd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:49:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:42912 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbgABQtd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jan 2020 11:49:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 08:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="221415089"
Received: from krominsx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.21.64])
  by orsmga006.jf.intel.com with ESMTP; 02 Jan 2020 08:49:30 -0800
Date:   Thu, 2 Jan 2020 18:49:30 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25 0/4] selftests/x86: x86/sgx: Minor selftest
 cleanup
Message-ID: <20200102164930.GA16919@linux.intel.com>
References: <20191220225501.23476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220225501.23476-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 20, 2019 at 02:54:57PM -0800, Sean Christopherson wrote:
> Add a .gitignore entry for the selftests and cleanup the includes to remove
> some homebrewed definitions in sgx/defines.h.
> 
> Sean Christopherson (4):
>   selftests/x86: Fix INCLUDES definition in SGX Makefile
>   x86/sgx: Add missing linux/bits.h include in sgx/arch.h
>   selftests/x86: Add .gitignore for SGX selftest
>   selftests/x86: Remove redundant kernel include
> 
>  arch/x86/kernel/cpu/sgx/arch.h             |  1 +
>  tools/testing/selftests/x86/sgx/.gitignore |  3 +++
>  tools/testing/selftests/x86/sgx/Makefile   |  3 ++-
>  tools/testing/selftests/x86/sgx/defines.h  | 22 ----------------------
>  tools/testing/selftests/x86/sgx/main.c     |  2 --
>  5 files changed, 6 insertions(+), 25 deletions(-)
>  create mode 100644 tools/testing/selftests/x86/sgx/.gitignore
> 
> -- 
> 2.24.1
> 

Thank you. I merged everything.

/Jarkko
