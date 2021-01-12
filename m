Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1A4C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC6B23132
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbhALXem (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 18:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733047AbhALXem (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 18:34:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA3FF2312F;
        Tue, 12 Jan 2021 23:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610494442;
        bh=5bJwDK2LMLE5X3yQ7nbT+RYXWs+hdUYbzZyvDWnadP0=;
        h=From:To:Cc:Subject:Date:From;
        b=V3nzz8ApxPJFTvvOZSHXgdpDbsGf8FG4xuV1YKIj2+PCf7Jn8MPQtZG9VfnLy6qTy
         4x7HS9LcSEbMQOjnOgn3BU48gR2VVwdX1yIVUYxC6NnQR/u2lBzHFvif2QiTyJvi1L
         DIYwaH3iQQudxGND2l9tB1+HhJYHaLk6+8AJTISMMDX9ORzWWQfXuKrQA+2hci8U+g
         8rkgrjwNtzM+jRNjE+S2EwPVngrswm3klVoqk0QLjTc8oGYqbsCS2FA/IAWw1vTh0j
         7u1VYrq2UwEcvryylSHmTEiEuJql8P21ABdT9NC0nFEIheonD78+vPEL060/kk3G/8
         f42oCaYOFUMRw==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: [PATCH v2 0/2] Take away EREMOVE from sgx_free_epc_page()
Date:   Wed, 13 Jan 2021 01:33:49 +0200
Message-Id: <20210112233351.68678-1-jarkko@kernel.org>
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

jarkko@kernel.org (2):
  x86/sgx: Remove a warn from sgx_free_epc_page()
  x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

 arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.29.2

