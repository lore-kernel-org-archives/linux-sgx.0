Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1394C3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20E92173E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfHVDcA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:32:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:4989 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbfHVDcA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:32:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:31:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="180241683"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 21 Aug 2019 20:31:59 -0700
Date:   Wed, 21 Aug 2019 20:31:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: [PATCH v3 0/7] Fix the reported SGX selftest makefile issues
Message-ID: <20190822033158.GQ29345@linux.intel.com>
References: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 04:28:23PM +0300, Jarkko Sakkinen wrote:
> Cedric Xing reported various issues in the selftest makefiles, which are
> hopefully taken care by these patches.
> 
> As the last patch this patch set contains a patch that implements the
> subdirectory traversal the for the x86 selftest directory tree. This
> patch is meant to be a separate patch in the main SGX patch set so that
> the bindings can be reviewed separately.

Doesn't have to be this series, but the build artifacts should be added
to .gitignore.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        sgx/encl.ss
        sgx/sgxsign
        sgx/test_sgx

> 
> v3: 1,$s/SUB_DIRS/SUBDIRS/g
> v2: Added patch to implement the traversal to the subdirectories
>     selftest.
> 
> Jarkko Sakkinen (7):
>   selftests/x86/sgx: Fix objcopy call in the Makefile
>   selftests/x86/sgx: Do not generate object files
>   selftests/x86/sgx: Add -I$(OUTPUT) when compiling encl_piggy.S
>   selftests/x86/sgx: Fix EXTRA_CLEAN
>   selftests/x86/sgx: Fix target in the Makefile
>   selftests/x86: Revert SGX changes
>   selftests/x86: Recurse into subdirectories
> 
>  tools/testing/selftests/x86/Makefile     | 54 +++++++++++++++++++-----
>  tools/testing/selftests/x86/sgx/Makefile | 33 ++++++++-------
>  tools/testing/selftests/x86/sgx/encl.lds |  1 +
>  3 files changed, 63 insertions(+), 25 deletions(-)
> 
> -- 
> 2.20.1
> 
