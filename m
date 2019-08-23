Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986AAC3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77219206E0
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393235AbfHWVxe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 17:53:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:33004 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392654AbfHWVxd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 17:53:33 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 14:53:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="196569047"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 23 Aug 2019 14:53:31 -0700
Date:   Fri, 23 Aug 2019 14:53:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: [PATCH 0/4] Remaining updates for v22
Message-ID: <20190823215327.GC24772@linux.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 07:16:12PM +0300, Jarkko Sakkinen wrote:
> These are my remaining updates for v22.

Tested, no issues found.

> 
> Jarkko Sakkinen (4):
>   x86/sgx: Replace @is_secs_child with @pt in sgx_encl_ewb()
>   x86/sgx: Validate TCS permssions in sgx_validate_secinfo()
>   x86/sgx: Remove a deperecated enum
>   x86/sgx: Move VM prot bits calculation to sgx_encl_page_alloc()
> 
>  arch/x86/kernel/cpu/sgx/encl.h    |  6 ----
>  arch/x86/kernel/cpu/sgx/ioctl.c   | 51 +++++++++++++++++--------------
>  arch/x86/kernel/cpu/sgx/reclaim.c | 43 ++++++++++++++++----------
>  3 files changed, 55 insertions(+), 45 deletions(-)
> 
> -- 
> 2.20.1
> 
