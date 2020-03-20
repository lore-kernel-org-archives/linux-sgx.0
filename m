Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A88FC4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 05:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC97A20722
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 05:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgCTFW7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 01:22:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:32606 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgCTFW7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 01:22:59 -0400
IronPort-SDR: spW39wVD8xzN6PWcXCAnWSuyHCIJy/n0SgdVV6H9N/TCRg8cDP64y0sIZXZem1Ni6FbOCx17SY
 qR1605L15R+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 22:22:58 -0700
IronPort-SDR: NdtTgSrxCK9TdRXUfUvtUHbB67YQTp5OyRlQ29Irhg1LGg/xBjFHbN00hD4PsCj5xY/2avtwZz
 3C5GRYcy26DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="268978820"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by fmsmga004.fm.intel.com with ESMTP; 19 Mar 2020 22:22:57 -0700
Date:   Fri, 20 Mar 2020 07:22:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Subject: selftests/x86/stgx: RSA_F4 -> RSA_3
Message-ID: <20200320052256.GA1248103@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi

Fixed error in gen_sign_key() and updated tree. Slipped in because
run old version of the selftest by mistake.

/Jarkko
