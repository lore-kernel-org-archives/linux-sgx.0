Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABD7C31E40
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 23:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F446208C4
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 23:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfHIXkf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 19:40:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:61319 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfHIXkf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 19:40:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 16:40:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,367,1559545200"; 
   d="scan'208";a="183039587"
Received: from wulili-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.36.9])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Aug 2019 16:40:32 -0700
Date:   Sat, 10 Aug 2019 02:40:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 07/11] x86/sgx: Check that enclave is created at
 beginning of EADD/EINIT ioctl
Message-ID: <20190809234032.kntlqgnyfenf6b7j@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808001254.11926-8-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:50PM -0700, Sean Christopherson wrote:
> Move the EADD/EINIT checks on SGX_ENCL_CREATED to the very beginning of
> the ioctl() flows.  Deferring the check until the core code is fragile
> as all code leading up to that point must be careful that it only uses
> members of @encl that are initialized at allocation time.  For example,
> the flush_work() call in sgx_encl_init() will crash if the enclave has
> not been created.
> 
> Note, there is no need to take encl->lock to check SGX_ENCL_CREATED so
> long as SGX_ENCL_CREATED is set only after the enclave is fully
> initialized, it's not the kernel's responsibility to guard against
> sgx_encl_create() racing with EADD/EINIT.  Add a comment to highlight
> the dependency.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

07/11, 08/11 and 09/11 have been squashed and pushed.

I'm now observing this kind of behavior with the self-test:

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
Input: 0x1122334455667788
Output: 0x1122334455667788

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
Input: 0x1122334455667788
Output: 0x1122334455667788

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
Input: 0x1122334455667788
Output: 0x1122334455667788

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
Input: 0x1122334455667788
Output: 0x1122334455667788

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
ECREATE failed rc=-1, err=22.

jsakkine at jsakkine-lab2 in ~/devel/linux-sgx (master●)
$ sudo tools/testing/selftests/x86/sgx/test_sgx
Binary size 24576 (0x6000), SIGSTRUCT size 1808
Loading the enclave.
Input: 0x1122334455667788
Output: 0x1122334455667788

Any ideas what could cause this? This happen with the current master.

/Jarkko
