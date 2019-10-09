Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD01ECE58D
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 14:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916A421848
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 14:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbfJIOH1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:07:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:38439 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbfJIOH1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 10:07:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 07:07:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="187632277"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga008.jf.intel.com with ESMTP; 09 Oct 2019 07:07:24 -0700
Date:   Wed, 9 Oct 2019 17:07:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, shay.katz-zamir@intel.com,
        serge.ayoun@intel.com
Subject: x86/sgx: v23-rc1
Message-ID: <20191009140723.GA18318@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Baseline before adding Sean's updates. This contains only my updates. I
spent this day mostly fixing diff's. Especially these two were somewhat
unclean:

1. x86/sgx: Add a page reclaimer
2. x86/sgx: Linux Enclave Driver

Now they pile up nicely (I think). So I decided to do this tag since now
commit's in the sense of form and shape are legit. And also because
things, well, work.

I'll continue from this by integrating Sean's changes. You can see below
what has been already changed.

/Jarkko

tag v23-rc1
Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date:   Wed Oct 9 16:59:10 2019 +0300

x86/sgx: v23-rc1 patch set

* Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
* In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
  (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
  flow can be only reverted by killing the whole enclave.
* Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
  it should have been bit 6 (Table 37-3 in the SDM).
* Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
  error code.
-----BEGIN PGP SIGNATURE-----

iJYEABYIAD4WIQRE6pSOnaBC00OEHEIaerohdGur0gUCXZ3nxCAcamFya2tvLnNh
a2tpbmVuQGxpbnV4LmludGVsLmNvbQAKCRAaerohdGur0mKVAQDcmIGs2f8y8hDY
b7zaQdNbaAMgsEkQ3ohMA88fbm2UQwD+P7y5AcAxzdccbgh++7RDy6XR2Ow2pluW
vCGUvRAhgwY=
=LCI3
-----END PGP SIGNATURE-----

/Jarkko
