Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16008C8301B
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 08:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E2122240
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 08:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgLBI2A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgLBI2A (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Dec 2020 03:28:00 -0500
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mihir Bhogilal Patel <Mihir.Patel@amd.com>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        xinhui pan <xinhui.pan@amd.com>
Subject: [PATCH 0/2] Fix some kernel-doc markups with wrong identifiers
Date:   Wed,  2 Dec 2020 09:27:13 +0100
Message-Id: <cover.1606897462.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

After applying this patch over next-20201201:

   https://lore.kernel.org/linux-doc/cover.1606823973.git.mchehab+huawei@kernel.org/T/#m0072adc6eb1af595a31fcc3b019cb81ab28c7b9f

There are a couple of new warnings that the kernel-doc prototype
doesn't match the documented function.

This series address them.

Mauro Carvalho Chehab (2):
  asm: sgx.h: fix a typo on a kernel-doc markup
  drm: amdgpu: fix a kernel-doc markup

 arch/x86/include/uapi/asm/sgx.h            | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.28.0


