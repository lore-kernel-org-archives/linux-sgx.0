Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDFBC433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 11 Jan 2021 22:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9C722CAF
	for <linux-sgx@archiver.kernel.org>; Mon, 11 Jan 2021 22:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbhAKWg6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbhAKWg6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 11 Jan 2021 17:36:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83AC522CAF;
        Mon, 11 Jan 2021 22:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610404577;
        bh=cjZnWRv1N9f1+o64V8ylU6WtFYQHYKuNWO6RaGtSyXI=;
        h=From:To:Cc:Subject:Date:From;
        b=MoVVwuWlwAPdZEQWiSpMa+nbxwokxSe18vZCen1Zh4FrAzxdlvZUjO8gD/qHHQl1P
         Lv8Mkidvx0FgcNbMgFBgg2/FwiZiG7qKT6dn4Wrzl+QSOp9npejv8OQcjWlbkyRwkl
         BLe9mLUdoIIyl7E/nYWlSsfWrSn/Xjtyodt50dgZ/Oy66FGvHBOxtnn3lFaZES0N9x
         gzWlU/E+DvDRXG40YkrtFK2EVE6wCXbpYHKYsYmYwXZ5iOfbsALBCOQFr8uBPNMwcf
         k1WbPoXSeYstq7OZAdmL8RyGU8VYfJgP+ahZzCZvZ86oKCUy0JOOQclBYk0lSSLSAK
         OyG2mGAo3vrLQ==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, dave.hansen@intel.com, haitao.huang@intel.com,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 0/2] x86/sgx: Take away EREMOVE from sgx_free_epc_page()
Date:   Tue, 12 Jan 2021 00:36:08 +0200
Message-Id: <20210111223610.62261-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Refactor EREMOVE out of sgx_free_epc_page() since it is only used in
one function.

I re-organized my Git a bit in order to keep track of things:

- 'master' bleading edge and 'next' ready PR ready branch
- 'numa' has nearly finished stuff, including the patches I'm
  posting now.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

jarkko@kernel.org (2):
  x86/sgx: Remove a warn from sgx_free_epc_page()
  x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

 arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.29.2

