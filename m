Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8669C48BE4
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B56D320645
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0S41 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:56:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:10284 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0S41 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 14:56:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 11:56:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="361259284"
Received: from bxing-desk.ccr.corp.intel.com (HELO ubt18.jf.intel.com) ([134.134.148.187])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jun 2019 11:56:25 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v2 0/3] security/x86/sgx: SGX specific LSM hooks
Date:   Thu, 27 Jun 2019 11:56:18 -0700
Message-Id: <cover.1561588012.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190619222401.14942-1-sean.j.christopherson@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
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
overhead. As you can see in the SELinux implementation of those new hooks
enclosed in this series, options are offered (via kernel command line
parameter) to system administrators between accurate auditing (decisions made
at the time of request) and low memory/performance overhead (decisions
made/cached ahead of time at page instantiation). And that’s one of the
benefits of keeping everything inside LSM.

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
  - Complicated/Restricted UAPI – Enclave loaders are required to provide
    “maximal protection” at page load time, but such information is NOT always
    available. For example, Graphene containers may run different applications
    comprised of different set of executables and/or shared objects. Some of
    them may contain self-modifying code (or text relocation) while others
    don’t. The generic enclave loader usually doesn’t have such information so
    wouldn’t be able to provide it ahead of time.
  - Inefficient Auditing – Audit logs are supposed to help system
    administrators to determine the set of minimally needed permissions and to
    detect abnormal behaviors. But consider the “maximal protection” model, if
    “maximal protection” is set to be too permissive, then audit log wouldn’t
    be able to detect anomalies; or if “maximal protection” is too restrictive,
    then audit log cannot identify the file violating the policy. In either
    case the audit log cannot fulfill its purposes.
  - Inability to support #PF driven EPC allocation in SGX2 – For those
    unfamiliar with SGX2 software flows, an SGX2 enclave requests a page by
    issuing EACCEPT on the address that a new page is wanted, and the resulted
    #PF is expected to be handled by the kernel by EAUG’ing an EPC page at the
    fault address, and then the enclave would be resumed and the faulting
    EACCEPT retried, and succeed. The key requirement is to allow mmap()’ing
    non-existing enclave pages so that the SGX module/subsystem could respond
    to #PFs by EAUG’ing new pages. Sean’s implementation doesn’t allow
    mmap()’ing non-existing pages for variety of reasons and therefore blocks
    this major SGX2 usage.

History:
  - This is version 2 of this patch series, with the following changes per
    comments/requests from the community:
    + A new data structure – EMA (Enclave Memory Area) is introduced to track
      range/origin correspondences for enclaves. EMAs are maintained by the LSM
      framework to be shared among all LSM modules. EMAs are allocated for
      enclave files only so will not impose overhead to regular
      applications/files.
    + Improved auditing – A new kernel command line option
      “lsm.ema.cache_decisions” is introduced, if on, would cause LSM modules
      to make/cache decisions at page instantiation (i.e. enclave_load() hook)
      instead of at time of request (i.e. file_mprotect() hook), in order to
      save memory by NOT keeping enclave source files open. System
      administrators are expected to run LSM in permissive mode along with this
      option off to figure out the minimal permissions necessary, then turn it
      back on in enforcing mode to minimize memory/performance overheads.
    + In the SELinux implementation of the new hooks, FILE__EXECUTE on the file
      containing SIGSTRUCT is interpreted as approval for launch, while
      FILE__EXECMOD is interpreted as allowing anonymous pages (i.e. pages
      EAUG’ed, or EADD’ed from an anonymous source page) to be executable.
      Allowed protections for other pages loaded from files are dictated by the
      source files’ FILE__EXECUTE/FILE__EXECMOD. This series intentionally
      avoids defining new permissions so that user mode tools could continue to
      work by treating enclave files the same way as regular executables and/or
      shared objects.
  - v1 –  https://patchwork.kernel.org/cover/10984127/

Cedric Xing (3):
  x86/sgx: Add SGX specific LSM hooks
  x86/sgx: Call LSM hooks from SGX subsystem/module
  x86/sgx: Implement SGX specific hooks in SELinux

 arch/x86/kernel/cpu/sgx/driver/ioctl.c |  80 ++++++++-
 arch/x86/kernel/cpu/sgx/driver/main.c  |  16 +-
 include/linux/lsm_ema.h                | 171 ++++++++++++++++++
 include/linux/lsm_hooks.h              |  29 ++++
 include/linux/security.h               |  23 +++
 security/Makefile                      |   1 +
 security/lsm_ema.c                     | 132 ++++++++++++++
 security/security.c                    |  47 ++++-
 security/selinux/hooks.c               | 229 ++++++++++++++++++++++++-
 security/selinux/include/objsec.h      |  24 +++
 10 files changed, 732 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/lsm_ema.h
 create mode 100644 security/lsm_ema.c

-- 
2.17.1

