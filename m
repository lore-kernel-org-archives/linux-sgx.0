Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D45EC74A21
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A5D2087F
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 15:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfGJPtQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 11:49:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:11557 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbfGJPtQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 11:49:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 08:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="341110149"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga005.jf.intel.com with ESMTP; 10 Jul 2019 08:49:15 -0700
Date:   Wed, 10 Jul 2019 08:49:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190710154915.GA4331@linux.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jul 07, 2019 at 04:41:34PM -0700, Cedric Xing wrote:
> selinux_enclave_init() determines if an enclave is allowed to launch, using the
> criteria described earlier. This implementation does NOT accept SIGSTRUCT in
> anonymous memory. The backing file is also cached in struct
> file_security_struct and will serve as the base for decisions for anonymous
> pages.

Did we ever reach a consensus on whether sigstruct must reside in a file?

> +	/* Store SIGSTRUCT file for future use */
> +	if (atomic_long_cmpxchg(&fsec->encl_ss, 0, (long)src->vm_file))
> +		return -EEXIST;
> +
> +	get_file(src->vm_file);

My understanding is that Andy is strongly against pinning a file for the
duration of the enclave, has that changed?
