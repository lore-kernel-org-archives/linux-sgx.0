Return-Path: <SRS0=ViI6=XJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B20C4CEC9
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 12:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24FAC2067B
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 12:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfINMPg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Sep 2019 08:15:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:56689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfINMPg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 14 Sep 2019 08:15:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Sep 2019 05:15:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="269724434"
Received: from krusocki-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.34])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2019 05:15:33 -0700
Date:   Sat, 14 Sep 2019 13:15:31 +0100
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com
Subject: /dev/sgx
Message-ID: <20190914121531.GA5400@linux.intel.com>
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

We might have a glitch in device management and I don't exactly know
what'd be the best way to resolve it.

Lets say that I add the following rule:

SUBSYSTEMS=="sgx", MODE="0666"

This will do the right thing to the devices but how to get the directory
permissions for /dev/sgx as 755?

Also when I do "udevadm trigger --verbose", I get the devices names
mangled in a strange way:

/sys/devices/sgx!enclave
/sys/devices/sgx!provision

/Jarkko
