Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29244C4360C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 11:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18B92053B
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 11:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfJJLhs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 07:37:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:31915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfJJLhs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 07:37:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 04:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,280,1566889200"; 
   d="scan'208";a="193979038"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.138])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2019 04:37:46 -0700
Date:   Thu, 10 Oct 2019 14:37:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: x86/sgx: v23-rc2
Message-ID: <20191010113745.GA12842@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

tag v23-rc2
Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date:   Thu Oct 10 14:33:07 2019 +0300

x86/sgx: v23-rc1 patch set

* Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
* In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
  (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
  flow can be only reverted by killing the whole enclave.
* Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
  it should have been bit 6 (Table 37-3 in the SDM).
* Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
  error code.
* In v22 __uaccess_begin() was used to pin the source page in
  __sgx_encl_add_page(). Switch to get_user_pages() in order to avoid
  deadlock (mmap_sem might get locked twice in the same thread).
-----BEGIN PGP SIGNATURE-----

iJYEABYIAD4WIQRE6pSOnaBC00OEHEIaerohdGur0gUCXZ8XTyAcamFya2tvLnNh
a2tpbmVuQGxpbnV4LmludGVsLmNvbQAKCRAaerohdGur0phXAP9QPYcpyUTSO9hk
sG/pV7vsIjS4lO6pxBCgWCtg3/ZkvAEApLCu7mFvyZs3rDcbOlQA+nQiVv+rUwzu
tsYmW2YsgQ4=
=VeL3
-----END PGP SIGNATURE-----

/Jarkko
