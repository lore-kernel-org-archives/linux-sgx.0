Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDD1C0650E
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3724B20693
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfGGXlr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 19:41:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:62277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfGGXlq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 19:41:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 16:41:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="340295303"
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.251.135.59])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2019 16:41:45 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v3 0/4] security/x86/sgx: SGX specific LSM hooks
Date:   Sun,  7 Jul 2019 16:41:30 -0700
Message-Id: <cover.1562542383.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1561588012.git.cedric.xing@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This series intends to make the new SGX subsystem to work with the existing LSM
architecture smoothly so that, say, SGX cannot be abused to work around
restrictions set forth by LSM modules/policies. 

This patch is based on and could be applied cleanly on top of Jarkko Sakkinen’s
SGX patch series v20 (https://patchwork.kernel.org/cover/10905141/).

For those who haven’t followed closely, the whole discussion started from the
primary question of how to prevent creating an executable enclave page from a
regular memory page that is NOT executable as prohibited by LSM
modules/policies. And that can be translated into 2 relating questions in
practice, i.e. 1) how to determine the allowed initial protections of enclave
pages when they are being loaded and 2) how to determine the allowed
protections of enclave pages at runtime. Those who are familiar with LSM may
notice that, for regular files, #1 is determined by security_mmap_file() while
#2 is covered by security_file_mprotect(). Those 2 hooks however are
insufficient for enclaves due to the distinct composition and lifespan of
enclave pages. Specifically, security_mmap_file() only passes in the file but
is not specific on which portion of the file being mmap()’ed, with the
assumption that all pages of the same file shall have the same set of
allowed/disallowed protections. But that assumption is no longer true for
enclaves for 2 reasons: a) pages of an enclave may be loaded from different
image files with different attributes and b) enclave pages retain contents
across munmap()/mmap(), therefore, say, if a policy prohibits execution of
modified pages, then pages flagged modified have to stay modified across
munmap()/mmap() so that the policy cannot be circumvented by remapping (i.e.
munmap() followed by mmap() on the same range). But the lack of range
information in security_mmap_file()’s arguments simply blocks LSM modules from
tracking enclave pages properly.

A rational solution would always involve tracking the correspondence between
enclave pages and their origin (e.g. files from which they were loaded), which
is similar to tracking regular memory pages and their origin via vm_file of
struct vm_area_struct. But given the longer lifespan of enclave pages (than
VMAs they are mapped into), such correspondence has to be stored in a separate
data structure outside of VMAs. In theory, the correspondence could be stored
either in LSM or in the SGX subsystem. This series has picked the former
because firstly, such information is useful only within LSM so it makes more
sense to keep it as “LSM internal” and secondly, keeping the data structure
inside LSM would allow additional information to be cached in LSM modules
without affecting the rest of the kernel, while lastly, those data structures
would be gone when LSM is disabled hence would not impose any unnecessary
overhead. 

Those who are familiar with this topic and related discussions may also notice
that, Sean Christopherson has sent out an RFC patch recently to address the
same problem as this series. He adopted the other approach of tracking
page/origin correspondence inside the SGX subsystem. However, to reduce memory
overhead in practice, he cached the FSM (Finite State Machine) instead of
page/origin correspondences. By “FSM”, I mean policy FSM defined as sets of
states and events that may trigger state transitions. Generally speaking, any
LSM module has its own definition of FSM and usually uses attributes attached
to files to argument the FSM, then it advances the FSM as events are observed
and gives out decision based on the current FSM state. Sean’s implementation
attempts to move the FSM into the SGX subsystem, and by caching the arguments
returned by LSM it tries to monitor events and reach the same decisions by
itself. So from architecture perspective, that model has to face tough
challenges in reality, such as how to support multiple LSM modules that employ
different FSMs to govern page protection transitions. Implementation wise, his
model also imposes unwanted restrictions specifically to SGX2, such as:
  · Complicated/Restricted UAPI – Enclave loaders are required to provide
    “maximal protection” at page load time, but such information is NOT always
    available. For example, Graphene containers may run different applications
    comprised of different set of executables and/or shared objects. Some of
    them may contain self-modifying code (or text relocation) while others
    don’t. The generic enclave loader usually doesn’t have such information so
    wouldn’t be able to provide it ahead of time.
  · Inefficient Auditing – Audit logs are supposed to help system
    administrators to determine the set of minimally needed permissions and to
    detect abnormal behaviors. But consider the “maximal protection” model, if
    “maximal protection” is set to be too permissive, then audit log wouldn’t
    be able to detect anomalies; or if “maximal protection” is too restrictive,
    then audit log cannot identify the file violating the policy. In either
    case the audit log cannot fulfill its purposes.
  · Inability to support #PF driven EPC allocation in SGX2 – For those
    unfamiliar with SGX2 software flows, an SGX2 enclave requests a page by
    issuing EACCEPT on the address that a new page is wanted, and the resulted
    #PF is expected to be handled by the kernel by EAUG’ing an EPC page at the
    fault address, and then the enclave would be resumed and the faulting
    EACCEPT retried, and succeed. The key requirement is to allow mmap()’ing
    non-existing enclave pages so that the SGX module/subsystem could respond
    to #PFs by EAUG’ing new pages. Sean’s implementation doesn’t allow
    mmap()’ing non-existing pages for variety of reasons and therefore blocks
    this major SGX2 usage.

Please note that this series has only been compile-tested.

History:
  · This is version 3 of this patch series, with the following changes over
    version 2 per comments/requests from the community.
    - Per Casey Schaufler, moved EMA from the LSM infrastructure into a new LSM
      module, named “ema”, which is responsible for maintaining EMA maps for
      enclaves and offers APIs for other LSM modules to query/update EMA nodes.
    - Per Stephen Smalley, removed kernel command line option
      “lsm.ema.cache_decisions”. Enclave page origins will always be tracked
      and audit logs will always be accurate.
    - Per Andy Lutomirski, a new PROCESS2__ENCLAVE_EXECANON permission has been
      added to SELinux to allow EADD’ing executable pages from non-executable
      anonymous source pages.
    - Revised permission checks for enclave pages in SELinux. See
      selinux_enclave_load() and enclave_mprotect() functions in
      security/selinux/hooks.c for details.
  · v2 – https://patchwork.kernel.org/cover/11020301/
  · v1 – https://patchwork.kernel.org/cover/10984127/

Cedric Xing (4):
  x86/sgx: Add SGX specific LSM hooks
  x86/64: Call LSM hooks from SGX subsystem/module
  X86/sgx: Introduce EMA as a new LSM module
  x86/sgx: Implement SGX specific hooks in SELinux

 arch/x86/kernel/cpu/sgx/driver/ioctl.c |  80 ++++++-
 arch/x86/kernel/cpu/sgx/driver/main.c  |  16 +-
 include/linux/lsm_ema.h                |  97 +++++++++
 include/linux/lsm_hooks.h              |  27 +++
 include/linux/security.h               |  23 ++
 security/Makefile                      |   1 +
 security/commonema.c                   | 277 +++++++++++++++++++++++++
 security/security.c                    |  17 ++
 security/selinux/hooks.c               | 236 ++++++++++++++++++++-
 security/selinux/include/classmap.h    |   3 +-
 security/selinux/include/objsec.h      |   7 +
 11 files changed, 770 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/lsm_ema.h
 create mode 100644 security/commonema.c

-- 
2.17.1

