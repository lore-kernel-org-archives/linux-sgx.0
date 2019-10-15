Return-Path: <SRS0=w1Tp=YI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974CAECE588
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 13:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74AD221925
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 13:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfJONqH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Oct 2019 09:46:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:24160 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732064AbfJONqH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Oct 2019 09:46:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 06:46:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="396816221"
Received: from em-moblenovo.ger.corp.intel.com (HELO localhost) ([10.252.17.238])
  by fmsmga006.fm.intel.com with ESMTP; 15 Oct 2019 06:46:04 -0700
Date:   Tue, 15 Oct 2019 16:46:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Subject: Selftests updated
Message-ID: <20191015134603.GA13189@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi

I split the selftest commit into two and added direct ENCLS[EENTER] call
path back (was taken away in v19). There is now a separate commit for
the basic vDSO selftest that can be refined. I reverted to v22 version
of the selftest because there were too many completely unnecessary
changes merged last week.

/Jarkko
