Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95138C4332B
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525842343E
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbhANB5N (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbhAMXpH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 18:45:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D762E233FC;
        Wed, 13 Jan 2021 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580953;
        bh=rjXg4k0Cgku7kGbFhfMtAuzNV+eowWewUrqRlPeMqN4=;
        h=From:To:Cc:Subject:Date:From;
        b=kgoTikYhPoTN14KIVuXC83lFMVZv+mkN2AsuERdGE8XVes/ks30+A6ZDTDIpYnvlN
         e11skSeaM6xnVvd52nJAoLbAZwj1Mw7v2sgXnxKFoV1wYwGXEtGN0zM0nL4ghbHX+l
         lZFHDXBNw7K3ieanPkO6L8I3/VDEVsWikzpwgekfbUvZHWMXzR0chIVbyPc33HVqDy
         l3+dO7cRrkfD9io5v00UnCaZqzx4fSKnTBXTObWlBwyU4X2W7sgjfMU7PYdNeAAZuW
         ewP7xjKSsN8jO3fLZqQTVrmoLQIif6WvrHs0YtjfmMPvNZseOfEFEo0zjbiJyXeVKp
         SyHRTenmJ6OqQ==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        seanjc@google.com, "jarkko@kernel.org" <jarkko@kernel.org>
Subject: [PATCH v4 0/2] Take away EREMOVE from sgx_free_epc_page()
Date:   Thu, 14 Jan 2021 01:35:39 +0200
Message-Id: <20210113233541.17669-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Refactor EREMOVE out of sgx_free_epc_page() since it is only used in
one function.

v4:
- No code changes to v4. Re-send because of
  "-to linux@sgx.vger.kernel.org"

jarkko@kernel.org (2):
  x86/sgx: Remove a warn from sgx_free_epc_page()
  x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

 arch/x86/kernel/cpu/sgx/encl.c | 13 +++++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.29.2

