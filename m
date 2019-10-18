Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D69CA9EA1
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A434C222BD
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbfJRKmN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:42:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:12661 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfJRKmN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 06:42:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 03:42:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="200673774"
Received: from glas-mobl.ger.corp.intel.com (HELO localhost) ([10.252.17.198])
  by orsmga006.jf.intel.com with ESMTP; 18 Oct 2019 03:42:10 -0700
Date:   Fri, 18 Oct 2019 13:42:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 03/12] x86/sgx: Fix EEXTEND error handling
Message-ID: <20191018104208.GA6423@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016183745.8226-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 11:37:36AM -0700, Sean Christopherson wrote:
> Rework EEXTEND error handling to fix issues related to destroying the
> enclave in response to EEXTEND failure.  At the time of EEXTEND, the
> page is already visibile in the sense that it has been added to the
> radix tree, and therefore will be processed by sgx_encl_destroy().  This
> means the "add" part needs to be fully completed prior to invoking
> sgx_encl_destroy() in order to avoid consuming half-baked state.
> 
> Move sgx_encl_destroy() to the call site of __sgx_encl_extend() so that
> it is somewhat more obvious why the add needs to complete before doing
> EEXTEND.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

First three (1, 2, 3) have been applied.

/Jarkko
