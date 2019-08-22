Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468E8C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 17:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2178D233FE
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 17:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfHVRBo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 13:01:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:50276 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729506AbfHVRBo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 13:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 10:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="208241819"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga002.fm.intel.com with ESMTP; 22 Aug 2019 10:01:41 -0700
Message-ID: <4c9f99553a8d830825ae1bc26a636193dc07ca32.camel@linux.intel.com>
Subject: Re: [PATCH v3] x86/sgx: Determine SECS at compile time in
 sgx_encl_eldu()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 22 Aug 2019 20:01:40 +0300
In-Reply-To: <20190822155501.8276-1-jarkko.sakkinen@linux.intel.com>
References: <20190822155501.8276-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 18:55 +0300, Jarkko Sakkinen wrote:
> Add @secs_page to sgx_encl_eldu() and @is_secs_child to sgx_encl_ewb()
> (replacing earlier @do_free) in order to state explicitly in the call
> site when we are using SECS. These replace the use of
> SGX_ENCL_PAGE_IS_SECS() macro.
> 
> In order to fully remove SGX_ENCL_PAGE_IS_SECS(), replace
> sgx_encl_get_index() with a macro SGX_ENCL_PAGE_INEX() as the
> conditional logic is no longer required.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> v3: Forgot to flip the conditions in __sgx_encl_eldu().

... actually I proactivly flipped the conditions wrong way in
v2 myself :-)

/Jarkko

